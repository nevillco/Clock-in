//
//  CIItemClockInsOverNotificationsDelegate.swift
//  Clock in
//
//  Created by Connor Neville on 6/15/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import Charts

class CIItemClockInsOverIntervalsDelegate: CIItemStatsChartDelegate {
    let formatter = NSDateFormatter()
    let item: CIModelItem
    
    required init(item: CIModelItem) {
        formatter.dateFormat = "M/dd/yy"
        self.item = item
    }
    
    func controlNames() -> [String] {
        let intervals = item.notificationIntervals
        var intervalStrings = intervals.map({ ">".stringByAppendingString(NSDate.stringForInterval(Int($0.value))) })
        intervalStrings.insert("all".localized, atIndex: 0)
        return intervalStrings
    }
    
    func chartType() -> ChartViewBase.Type {
        return BarChartView.self
    }
    
    func xValues(selectedButtonIndex:Int) -> [String] {
        formatter.dateFormat = "M/dd/yy"
        var currentDate = item.createDate.roundToDay()
        let sortedEntries = item.entries.sorted("startDate", ascending: true)
        let lastDate = sortedEntries.last!.startDate
        var xValues:[String] = []
        let minimumXValues = 5
        while(currentDate.timeIntervalSinceDate(lastDate) <= 0.0 || xValues.count < minimumXValues) {
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
            let selectedInterval:Double = (selectedButtonIndex == 0) ?
            0 : item.notificationIntervals[selectedButtonIndex - 1].value
            
            let includeConditional = entryDate.sameDay(dateToCompare) &&
                entry.time >= selectedInterval
            if includeConditional {
                total += 1
            }
        }
        return total
    }
    
    func loadChartData(chart: ChartViewBase, selectedButtonIndex:Int) {
        let xValues = self.xValues(selectedButtonIndex)
        var dataEntries:[BarChartDataEntry] = []
        for i in 0..<xValues.count {
            let value = yValue(atXLabel: xValues[i], selectedButtonIndex: selectedButtonIndex)
            dataEntries.append(BarChartDataEntry(value: value, xIndex: i))
        }
        
        let dataSet = BarChartDataSet(yVals: dataEntries, label: "")
        dataSet.colors = [UIColor.whiteColor().colorWithAlphaComponent(0.6)]
        dataSet.drawValuesEnabled = false
        dataSet.highlightColor = UIColor.whiteColor()
        dataSet.highlightLineWidth = 10
        dataSet.highlightAlpha = 0.5
        dataSet.highlightEnabled = true
        
        let data = BarChartData(xVals: xValues, dataSet: dataSet)
        
        chart.data = data
    }
    
    func setMinimumAxisRange(chart: ChartViewBase) {
        let barChart = chart as! BarChartView
        barChart.leftAxis.resetCustomAxisMax()
        barChart.leftAxis.axisMaxValue = max(barChart.leftAxis.axisMaxValue, 7.0)
    }
    
    func styleChart(chart: ChartViewBase) {
        let barChart = chart as! BarChartView
        barChart.descriptionText = ""
        barChart.extraRightOffset = CIConstants.chartRightOffset
        barChart.extraLeftOffset = CIConstants.chartLeftOffset
        barChart.drawValueAboveBarEnabled = false
        
        barChart.legend.enabled = false
        
        barChart.rightAxis.enabled = false
        
        barChart.leftAxis.labelFont = .CIChartAxisLabelFont
        barChart.leftAxis.labelTextColor = .whiteColor()
        barChart.leftAxis.gridColor = .whiteColor()
        barChart.leftAxis.axisLineColor = .whiteColor()
        barChart.leftAxis.axisLineWidth = 2.0
        let formatter = NSNumberFormatter()
        formatter.maximumFractionDigits = 0
        barChart.leftAxis.valueFormatter = formatter
        barChart.leftAxis.axisMinValue = 0
        
        barChart.xAxis.labelFont = .CIChartAxisLabelFont
        barChart.xAxis.labelTextColor = .whiteColor()
        barChart.xAxis.labelPosition = .Bottom
        barChart.xAxis.axisLineColor = .whiteColor()
        barChart.xAxis.axisLineWidth = 2.0
        barChart.xAxis.gridLineWidth = 0.0
    }
    
    func chartTitle(selectedButtonIndex: Int) -> String {
        return "Clock-ins Over Notification Times".localized
    }
    
    func formatSelectedValues(xValue: String, yValue: Double, selectedButtonIndex: Int) -> (String, String) {
        formatter.dateFormat = "M/dd/yy"
        let xDate = formatter.dateFromString(xValue)!
        formatter.dateFormat = "MMMM d"
        var yString = String(format: "%d CLOCK-IN%@", Int(yValue), (Int(yValue) == 1 ? "" : "S"))
        if selectedButtonIndex > 0 {
            let selectedInterval = item.notificationIntervals[selectedButtonIndex-1].value
            yString = yString.stringByAppendingString(String(format: " OVER %@", NSDate.longStringForInterval(Int(selectedInterval)).uppercaseString))
        }
        return (formatter.stringFromDate(xDate).uppercaseString, yString)
    }
}