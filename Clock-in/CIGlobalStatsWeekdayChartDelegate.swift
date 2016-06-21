//
//  CIGlobalStatsWeekdayChartDelegate.swift
//  Clock-in
//
//  Created by Connor Neville on 6/20/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import Charts
import RealmSwift

class CIGlobalStatsWeekdayChartDelegate: CIGlobalStatsChartDelegate {
    let formatter = NSDateFormatter()
    func chartType() -> ChartViewBase.Type {
        return BarChartView.self
    }
    
    func xValues(selectedItems:[CIModelItem]) -> [String] {
        return formatter.weekdaySymbols
    }
    
    func yValue(atXLabel xLabel:String, selectedItem:CIModelItem) -> Double? {
        let index = formatter.weekdaySymbols.indexOf(xLabel)!
        let component = NSCalendarUnit.Weekday
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        
        var total:Double = 0.0
        for entry in selectedItem.entries {
            let component = calendar.component(component, fromDate: entry.startDate)
            if ((component - 1) == index) {
                total += entry.time
            }
        }
        return total

    }
    
    func loadChartData(chart: ChartViewBase, selectedItems: [CIModelItem]) {
        let xValues = self.xValues(selectedItems)
        let data = BarChartData(xVals: xValues)
        for item in selectedItems {
            var dataEntries:[BarChartDataEntry] = []
            for i in 0..<xValues.count {
                let value = yValue(atXLabel: xValues[i], selectedItem: item)
                dataEntries.append(BarChartDataEntry(value: value!, xIndex: i))
            }
            
            let dataSet = BarChartDataSet(yVals: dataEntries, label: "")
            dataSet.colors = [UIColor.colorForItem(item).colorWithAlphaComponent(0.6)]
            dataSet.drawValuesEnabled = false
            dataSet.highlightEnabled = true
            dataSet.highlightColor = UIColor.colorForItem(item)
            dataSet.highlightLineWidth = 2.0
            data.addDataSet(dataSet)
        }
        (chart as! BarChartView).leftAxis.axisMaxValue = max(10.0, ceil(data.yMax))
        
        chart.data = data
    }
    
    func setAxisLabels(chart: ChartViewBase) {
        let barChart = chart as! BarChartView
        if barChart.leftAxis.labelCount > Int(barChart.chartYMax) {
            barChart.leftAxis.setLabelCount(Int(barChart.chartYMax) + 1, force: true)
        }
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
        barChart.leftAxis.labelTextColor = .blackColor()
        barChart.leftAxis.gridColor = .blackColor()
        barChart.leftAxis.axisLineColor = .blackColor()
        barChart.leftAxis.axisLineWidth = 2.0
        barChart.leftAxis.valueFormatter = CIChartIntervalFormatter()
        barChart.leftAxis.granularity = 1.0
        barChart.leftAxis.axisMinValue = 0
        
        barChart.xAxis.labelFont = .CIChartAxisLabelFont
        barChart.xAxis.labelTextColor = .blackColor()
        barChart.xAxis.labelPosition = .Bottom
        barChart.xAxis.axisLineColor = .blackColor()
        barChart.xAxis.axisLineWidth = 2.0
        barChart.xAxis.gridLineWidth = 0.0
    }
    
    func chartTitle() -> String {
        return "Clocked Time by Weekday".localized
    }
    
    func formatSelectedValues(xValue: String, yValue: Double, selectedItem: CIModelItem) -> (String, String) {
        let xString = String(format: "%@S - %@", xValue.uppercaseString, selectedItem.name.uppercaseString)
        return (xString, NSDate.longStringForInterval(Int(yValue)).uppercaseString)
    }
}