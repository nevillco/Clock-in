//
//  CIGlobalStatsChartViewController.swift
//  Clock-in
//
//  Created by Connor Neville on 6/20/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import Foundation
import Charts
import RealmSwift

class CIGlobalStatsChartViewController: CIViewController, ChartViewDelegate {
    let delegate:CIGlobalStatsChartDelegate
    required init(delegate: CIGlobalStatsChartDelegate) {
        self.delegate = delegate
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let view = CIGlobalStatsChartView(items: allItems(), delegate: delegate)
        delegate.styleChart(view.chart)
        addTargets(view)
        addDelegates(view)
        self.view = view
        loadData()
    }
    
    func allItems() -> [CIModelItem] {
        let realm = try! Realm()
        let items = realm.objects(CIModelItem.self)
        return items.map({ $0 })
    }
    
    func selectedItems() -> [CIModelItem] {
        let view = self.view as! CIGlobalStatsChartView
        let items = allItems()
        let selectedIndices:[Bool] = view.buttons.map({ $0.permanentHighlight })
        var selectedItems:[CIModelItem] = []
        for i in 0..<selectedIndices.count {
            if(selectedIndices[i]) { selectedItems.append(items[i]) }
        }
        return selectedItems.filter({ $0.entries.count > 0 })
    }
    
    func hasData(selectedItems: [CIModelItem]) -> Bool {
        let totalEntries = selectedItems.map({ $0.entries.count }).reduce(0, combine: +)
        return totalEntries > 0
    }
    
    func itemButtonPressed(sender: UIButton) {
        let button = sender as! CIButton
        button.permanentHighlight = !button.permanentHighlight
        loadData()
    }
    
    func loadData() {
        let view = self.view as! CIGlobalStatsChartView
        view.animateTitleMessage("Loading...".localized)
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            let items = self.selectedItems()
            if(self.hasData(items)) {
                self.delegate.loadChartData(view.chart, selectedItems:items)
                self.delegate.setAxisLabels(view.chart)
                dispatch_async(dispatch_get_main_queue()) {
                    view.animateTitleMessage(self.delegate.chartTitle())
                    view.chart.notifyDataSetChanged()
                    
                    view.noDataLabel.alpha = 0
                    view.selectedPointInfoLabel.text = "TAP A DATA POINT FOR MORE".localized
                    view.selectedPointDataLabel.text = " "
                    view.selectedPointDataLabel.alpha = 1
                    view.selectedPointInfoLabel.alpha = 1
                    view.selectionContainer.alpha = 1
                    view.chart.alpha = 1
                    
                    view.chart.highlightValue(xIndex: -1, dataSetIndex: 0)
                    view.chart.animate(yAxisDuration: 0.5)
                }
            }
            else {
                dispatch_async(dispatch_get_main_queue()) {
                    view.animateTitleMessage(self.delegate.chartTitle())
                    view.noDataLabel.alpha = 1
                    view.selectedPointDataLabel.alpha = 0
                    view.selectedPointInfoLabel.alpha = 0
                    view.selectionContainer.alpha = 0
                    view.chart.alpha = 0
                }
            }
        }
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        let view = self.view as! CIGlobalStatsChartView
        let itemCount = selectedItems().count
        let selectedItem:CIModelItem
        if chartView.data!.dataSetCount == itemCount {
            selectedItem = selectedItems()[dataSetIndex]
        }
        else {
            selectedItem = selectedItems()[entry.xIndex]
        }
        let xValue = delegate.xValues(selectedItems())[entry.xIndex]
        let yValue = delegate.yValue(atXLabel: xValue, selectedItem: selectedItem)
        let (formattedX, formatterY) = delegate.formatSelectedValues(xValue, yValue: yValue, selectedItem: selectedItem)
        view.selectedPointInfoLabel.text = formattedX
        view.selectedPointDataLabel.text = formatterY
        view.selectionContainer.backgroundColor = UIColor.colorForItem(selectedItem)
    }
}

private extension CIGlobalStatsChartViewController {
    func addTargets(view: CIGlobalStatsChartView) {
        for button in view.buttons {
            button.addTarget(self, action: #selector(itemButtonPressed(_:)), forControlEvents: .TouchUpInside)
        }
    }
    
    func addDelegates(view: CIGlobalStatsChartView) {
        view.chart.delegate = self
    }
}
