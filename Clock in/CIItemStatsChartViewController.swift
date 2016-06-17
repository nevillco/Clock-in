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
        chartButtonPressed(view.buttons[0])
    }
    
    func chartButtonPressed(sender: UIButton) {
        let view = self.view as! CIItemStatsChartView
        let index = view.buttons.indexOf(sender as! CIButton)!
        for i in 0..<view.buttons.count {
            view.buttons[i].permanentHighlight = (i == index)
        }
        
        if item.entries.count > 0 {
            delegate.loadChartData(view.chart, selectedButtonIndex:index)
            delegate.setAxisLabels(view.chart)
            view.chart.notifyDataSetChanged()
            
            view.titleLabel.text = delegate.chartTitle(index)
            view.noDataLabel.alpha = 0
            view.selectedPointInfoLabel.text = "TAP A DATA POINT FOR MORE".localized
            view.selectedPointDataLabel.text = " "
            view.selectedPointDataLabel.alpha = 1
            view.selectedPointInfoLabel.alpha = 1
            
            view.chart.highlightValue(xIndex: -1, dataSetIndex: 0)
            view.chart.animate(yAxisDuration: 0.5)
        }
        else {
            view.noDataLabel.alpha = 1
            view.selectedPointDataLabel.alpha = 0
            view.selectedPointInfoLabel.alpha = 0
        }
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        let view = self.view as! CIItemStatsChartView
        var selectedIndex:Int = 0
        for i in 1..<view.buttons.count {
            if view.buttons[i].permanentHighlight { selectedIndex = i }
        }
        let xValue = delegate.xValues(selectedIndex)[entry.xIndex]
        let yValue = delegate.yValue(atXLabel: xValue, selectedButtonIndex: selectedIndex)
        let (formattedX, formatterY) = delegate.formatSelectedValues(xValue, yValue: yValue, selectedButtonIndex: selectedIndex)
        view.selectedPointInfoLabel.text = formattedX
        view.selectedPointDataLabel.text = formatterY
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
