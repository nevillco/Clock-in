//
//  GIClobalStatsPieChartDelegate.swift
//  Clock-in
//
//  Created by Connor Neville on 6/20/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import Charts
import RealmSwift

class CIGlobalStatsPieChartDelegate: CIGlobalStatsChartDelegate {
    func chartType() -> ChartViewBase.Type {
        return PieChartView.self
    }
    
    func xValues(selectedItems:[CIModelItem]) -> [String] {
        return selectedItems.map({ $0.name })
    }
    
    func yValue(atXLabel xLabel:String, selectedItem:CIModelItem) -> Double {
        return selectedItem.entries.map({ $0.time }).reduce(0, combine: +)
        
    }
    
    func loadChartData(chart: ChartViewBase, selectedItems: [CIModelItem]) {
        let xVals = xValues(selectedItems)
        var dataEntries:[ChartDataEntry] = []
        for i in 0..<xVals.count {
            let entry = ChartDataEntry(value: yValue(atXLabel: xVals[i], selectedItem: selectedItems[i]), xIndex: i)
            dataEntries.append(entry)
        }
        let dataSet = PieChartDataSet(yVals: dataEntries, label: nil)
        dataSet.valueFont = UIFont.CIDefaultBodyFont
        dataSet.colors = selectedItems.map({ UIColor.colorForItem($0) })
        
        let data = PieChartData(xVals: xVals, dataSet: dataSet)
        data.setDrawValues(false)
        chart.data = data
    }
    
    func setAxisLabels(chart: ChartViewBase) {
        
    }
    
    func styleChart(chart: ChartViewBase) {
        let pieChart = chart as! PieChartView
        pieChart.descriptionText = ""
        pieChart.drawSliceTextEnabled = true
        
        pieChart.legend.enabled = false
    }
    
    func chartTitle() -> String {
        return "Total Clocked Time".localized
    }
    
    func formatSelectedValues(xValue: String, yValue: Double, selectedItem: CIModelItem) -> (String, String) {
        return (xValue.uppercaseString, NSDate.longStringForInterval(Int(yValue)).uppercaseString)
    }
}