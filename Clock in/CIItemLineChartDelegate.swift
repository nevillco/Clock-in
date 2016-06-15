//
//  CILineGraphDelegate.swift
//  Clock in
//
//  Created by Connor Neville on 6/13/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import Charts

class CIItemLineChartDelegate: CIItemStatsChartDelegate {
    let formatter = NSDateFormatter()
    let item: CIModelItem
    
    required init(item: CIModelItem) {
        self.item = item
    }
    
    func controlNames() -> [String] {
        return ["default".localized, "cumulative".localized]
    }
    
    func chartType() -> ChartViewBase.Type {
        return LineChartView.self
    }
    
    func xValues(selectedButtonIndex:Int) -> [String] {
        formatter.dateFormat = "M/dd/yy"
        var currentDate = item.createDate.roundToDay()
        let sortedEntries = item.entries.sorted("startDate", ascending: true)
        let lastDate = sortedEntries.last!.startDate
        var xValues:[String] = []
        while(currentDate.timeIntervalSinceDate(lastDate) <= 0.0) {
            xValues.append(formatter.stringFromDate(currentDate))
            currentDate = currentDate.advancedByDays(1)
        }
        return xValues
    }
    
    func yValue(atXLabel xLabel:String, selectedButtonIndex:Int) -> Double {
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
        let xValues = self.xValues(selectedButtonIndex)
        var dataEntries:[ChartDataEntry] = []
        for i in 0..<xValues.count {
            let value = yValue(atXLabel: xValues[i], selectedButtonIndex: selectedButtonIndex)
            dataEntries.append(ChartDataEntry(value: value, xIndex: i))
        }
        
        let dataSet = LineChartDataSet(yVals: dataEntries, label: "")
        dataSet.circleColors = [UIColor.whiteColor()]
        dataSet.circleRadius = 6.0
        dataSet.lineWidth = 2.0
        dataSet.colors = [UIColor.whiteColor()]
        dataSet.drawValuesEnabled = false
        dataSet.drawFilledEnabled = true
        dataSet.highlightEnabled = false
        
        let data = LineChartData(xVals: xValues, dataSet: dataSet)
        
        chart.data = data
    }
    
    func styleChart(chart: ChartViewBase) {
        let lineChart = chart as! LineChartView
        lineChart.descriptionText = ""
        lineChart.extraRightOffset = CIConstants.chartRightOffset
        lineChart.extraLeftOffset = CIConstants.chartLeftOffset
        
        lineChart.legend.enabled = false
        
        lineChart.rightAxis.enabled = false
        
        lineChart.leftAxis.labelFont = .CIChartAxisLabelFont
        lineChart.leftAxis.labelTextColor = .whiteColor()
        lineChart.leftAxis.gridColor = .whiteColor()
        lineChart.leftAxis.axisLineColor = .whiteColor()
        lineChart.leftAxis.axisLineWidth = 2.0
        lineChart.leftAxis.valueFormatter = CIChartIntervalFormatter()
        lineChart.leftAxis.axisMinValue = 0
        
        lineChart.xAxis.labelFont = .CIChartAxisLabelFont
        lineChart.xAxis.labelTextColor = .whiteColor()
        lineChart.xAxis.labelPosition = .Bottom
        lineChart.xAxis.axisLineColor = .whiteColor()
        lineChart.xAxis.axisLineWidth = 2.0
        lineChart.xAxis.gridLineWidth = 0.0
    }
    
    func hasSufficientData(selectedButtonIndex: Int) -> Bool {
        if item.entries.count == 0 { return false }
        let xVals = xValues(selectedButtonIndex)
        let yValues = xVals.map({ self.yValue(atXLabel: $0, selectedButtonIndex: selectedButtonIndex) })
        let max = Int(yValues.maxElement()!)
        return max >= 10
    }
    
    func descriptionForNoData() -> String {
        return "This chart requires you have one day with at least 10 seconds of time clocked in.".localized;
    }
    
    func chartTitle(selectedButtonIndex: Int) -> String {
        return "Clocked Time by Day".localized
    }
}