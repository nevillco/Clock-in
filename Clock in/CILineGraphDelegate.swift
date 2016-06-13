//
//  CILineGraphDelegate.swift
//  Clock in
//
//  Created by Connor Neville on 6/13/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import Charts

class CILineGraphDelegate: CIItemStatsChartDelegate {
    let formatter = NSDateFormatter()
    let item: CIModelItem
    
    init(item: CIModelItem) {
        self.item = item
    }
    
    func controlNames() -> [String] {
        return ["default".localized, "cumulative".localized]
    }
    
    func chartType() -> ChartViewBase.Type {
        return LineChartView.self
    }
    
    func xValues(forItem item:CIModelItem, selectedButtonIndex:Int) -> [String] {
        formatter.dateFormat = "M/dd/yy"
        var currentDate = item.createDate.roundToDay()
        var xValues:[String] = []
        while(currentDate.timeIntervalSinceNow < 0.0) {
            xValues.append(formatter.stringFromDate(currentDate))
            currentDate = currentDate.advancedByDays(1)
        }
        return xValues
    }
    
    func yValue(atXLabel xLabel:String, forItem item:CIModelItem, selectedButtonIndex:Int) -> Double {
        formatter.dateFormat = "M/dd/yy"
        var total = 0.0
        for entry in item.entries {
            let dateToCompare = formatter.dateFromString(xLabel)!.roundToDay()
            let entryDate = entry.startDate.roundToDay()
            let includeConditional = (selectedButtonIndex == 0) ?
            entryDate.sameDay(dateToCompare) :
            entryDate.timeIntervalSinceDate(dateToCompare) <= 0
            if includeConditional {
                total += entry.time
            }
        }
        return total
    }
    
    func loadChartData(chart: ChartViewBase, selectedButtonIndex:Int) {
        let xValues = self.xValues(forItem: item, selectedButtonIndex:selectedButtonIndex)
        var dataEntries:[ChartDataEntry] = []
        for i in 0..<xValues.count {
            let value = yValue(atXLabel: xValues[i], forItem: item, selectedButtonIndex: selectedButtonIndex)
            dataEntries.append(ChartDataEntry(value: value, xIndex: i))
        }
        let dataSet = LineChartDataSet(yVals: dataEntries, label: "Clock time by day")
        let data = LineChartData(xVals: xValues, dataSet: dataSet)
        chart.data = data
    }
}