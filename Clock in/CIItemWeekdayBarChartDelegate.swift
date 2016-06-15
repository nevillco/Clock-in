//
//  CIItemWeekdayBarChartDelegate.swift
//  Clock in
//
//  Created by Connor Neville on 6/14/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import Charts
import RealmSwift

class CIItemWeekdayBarChartDelegate: CIItemStatsChartDelegate {
    let item: CIModelItem
    
    required init(item: CIModelItem) {
        self.item = item
    }
    
    func controlNames() -> [String] {
        return ["weekdays", "months"]
    }
    
    func chartType() -> ChartViewBase.Type {
        return BarChartView.self
    }
    
    func xValues(selectedButtonIndex:Int) -> [String] {
        if selectedButtonIndex == 0 {
            return ["S", "M", "T", "W", "T", "F", "S"]
        }
        else {
            return ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"]
        }
    }
    
    func yValue(atXLabel xLabel:String, selectedButtonIndex:Int) -> Double {
        let index = xValues(selectedButtonIndex).indexOf(xLabel)!
        let component = selectedButtonIndex == 0 ? NSCalendarUnit.Weekday : NSCalendarUnit.Month
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        
        var total:Double = 0.0
        for entry in item.entries {
            let component = calendar.component(component, fromDate: entry.startDate)
            if ((component - 1) == index) {
                total += entry.time
            }
        }
        print(xLabel, total)
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
        dataSet.highlightColor = UIColor.clearColor()
        dataSet.highlightEnabled = true
        
        let data = BarChartData(xVals: xValues, dataSet: dataSet)
        
        chart.data = data
    }
    
    func styleChart(chart:ChartViewBase) {
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
        barChart.leftAxis.valueFormatter = CIChartIntervalFormatter()
        barChart.leftAxis.axisMinValue = 0
        
        barChart.xAxis.labelFont = .CIChartAxisLabelFont
        barChart.xAxis.labelTextColor = .whiteColor()
        barChart.xAxis.labelPosition = .Bottom
        barChart.xAxis.axisLineColor = .whiteColor()
        barChart.xAxis.axisLineWidth = 2.0
        barChart.xAxis.gridLineWidth = 0.0
    }
    
    func hasSufficientData(selectedButtonIndex:Int) -> Bool {
        return item.entries.count > 0
        
    }
    
    func descriptionForNoData() -> String {
        return "This chart requires you clock in at least once.".localized
    }
    
    func chartTitle(selectedButtonIndex: Int) -> String {
        return (selectedButtonIndex == 0) ? "Clocked Time by Weekday".localized : "Clocked Time by Month".localized
    }
}