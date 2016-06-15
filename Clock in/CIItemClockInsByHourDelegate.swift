//
//  CIItemClockInsByHourDelegate.swift
//  Clock in
//
//  Created by Connor Neville on 6/15/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import Charts

class CIItemClockInsByHourDelegate: CIItemStatsChartDelegate {
    let formatter = NSDateFormatter()
    let item: CIModelItem
    
    required init(item: CIModelItem) {
        formatter.dateFormat = "M/dd/yy"
        self.item = item
    }
    
    func controlNames() -> [String] {
        return ["total".localized, "today".localized, "this week".localized]
    }
    
    func chartType() -> ChartViewBase.Type {
        return BarChartView.self
    }
    
    func xValues(selectedButtonIndex:Int) -> [String] {
        return ["12am", "1am", "2am", "3am", "4am", "5am", "6am", "7am", "8am", "9am", "10am", "11am",
                "12pm", "1pm", "2pm", "3pm", "4pm", "5pm", "6pm", "7pm", "8pm", "9pm", "10pm", "11pm"]
    }
    
    func yValue(atXLabel xLabel:String, selectedButtonIndex:Int) -> Double {
        formatter.dateFormat = "M/dd/yy"
        var total = 0.0
        for entry in item.entries {
            let entryDate = entry.startDate
            let hourOfEntry = NSCalendar.currentCalendar().component(.Hour, fromDate: entryDate)
            let desiredHour = xValues(selectedButtonIndex).indexOf(xLabel)!
            var includeConditional = (hourOfEntry == desiredHour)
            if selectedButtonIndex == 1 { includeConditional = includeConditional && (NSDate().timeIntervalSinceDate(entry.startDate) < (60*60*24)) }
            else if selectedButtonIndex == 2 { includeConditional = includeConditional && (NSDate().timeIntervalSinceDate(entry.startDate) < (60*60*24*7)) }
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
        dataSet.colors = [UIColor.whiteColor()]
        dataSet.drawValuesEnabled = false
        dataSet.barBorderColor = .whiteColor()
        dataSet.barBorderWidth = CIConstants.borderWidth
        dataSet.highlightColor = UIColor.colorForItem(item)
        dataSet.highlightAlpha = 1.0
        dataSet.highlightEnabled = true
        dataSet.barSpace = 0.50
        
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
        return "Clock-ins By Hour".localized
    }
    
    func formatSelectedValues(xValue: String, yValue: Double, selectedButtonIndex: Int) -> (String, String) {
        var yString = String(format: "%d CLOCK%@ ", Int(yValue), (Int(yValue) == 1 ? "" : "S"))
        yString = yString.stringByAppendingString(controlNames()[selectedButtonIndex].uppercaseString)
        return (xValue.uppercaseString, yString)
    }
}