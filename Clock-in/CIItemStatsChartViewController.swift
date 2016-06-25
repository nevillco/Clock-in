//
//  CIStatsChartViewController.swift
//  Clock in
//
//  Created by Connor Neville on 6/13/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import Foundation
import Charts

class CIItemStatsChartViewController: CIViewController, ChartViewDelegate {
    let delegate:CIItemStatsChartDelegate
    let item: CIModelItem
    required init(item: CIModelItem, delegate: CIItemStatsChartDelegate) {
        self.item = item
        self.delegate = delegate
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CIItemStatsChartView(color: UIColor.colorForItem(item), delegate: delegate)
        delegate.styleChart(view.chart)
        addTargets(view)
        addDelegates(view)
        self.view = view
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        let view = self.view as! CIItemStatsChartView
        view.chart.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let view = self.view as! CIItemStatsChartView
        chartButtonPressed(view.buttons[0])
    }
    
    func chartButtonPressed(sender: UIButton) {
        let view = self.view as! CIItemStatsChartView
        let index = view.buttons.indexOf(sender as! CIButton)!
        for i in 0..<view.buttons.count {
            view.buttons[i].permanentHighlight = (i == index)
        }
        loadData(index)
    }
    
    func loadData(index:Int) {
        let view = self.view as! CIItemStatsChartView
        view.titleLabel.text = "Loading...".localized
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            self.delegate.loadChartData(view.chart, selectedButtonIndex:index)
            self.delegate.setAxisLabels(view.chart)
            dispatch_async(dispatch_get_main_queue()) {
                view.chart.alpha = 1
                view.chart.animate(yAxisDuration: 0.5)
                view.animateTitleMessage(self.delegate.chartTitle(index))
                
                view.selectedPointInfoLabel.text = "TAP A DATA POINT FOR MORE".localized
                view.selectedPointDataLabel.text = " "
                
                view.chart.highlightValue(xIndex: -1, dataSetIndex: 0)
            }
        }
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        let view = self.view as! CIItemStatsChartView
        var selectedIndex:Int = 0
        for i in 1..<view.buttons.count {
            if view.buttons[i].permanentHighlight { selectedIndex = i }
        }
        let xValue = delegate.xValues(selectedIndex)[entry.xIndex]
        let yValue = delegate.yValue(atXLabel: xValue, selectedButtonIndex: selectedIndex) ?? 0
        let (formattedX, formatterY) = delegate.formatSelectedValues(xValue, yValue: yValue, selectedButtonIndex: selectedIndex)
        view.selectedPointInfoLabel.text = formattedX
        view.selectedPointDataLabel.text = formatterY
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        let view = self.view as! CIItemStatsChartView
        view.selectedPointInfoLabel.text = "TAP A DATA POINT FOR MORE".localized
        view.selectedPointDataLabel.text = " "
    }
}

private extension CIItemStatsChartViewController {
    func addTargets(view: CIItemStatsChartView) {
        for button in view.buttons {
            button.addTarget(self, action: #selector(chartButtonPressed(_:)), forControlEvents: .TouchUpInside)
        }
    }
    
    func addDelegates(view: CIItemStatsChartView) {
        view.chart.delegate = self
    }
}
