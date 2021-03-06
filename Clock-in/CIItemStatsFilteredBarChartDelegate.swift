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

class CIItemStatsFilteredBarChartDelegate: CIItemStatsChartDelegate {
    let itemName: String
    
    required init(itemName: String) {
        self.itemName = itemName
    }
    
    func controlNames() -> [String] {
        return ["weekdays", "months"]
    }
    
    func chartType() -> ChartViewBase.Type {
        return BarChartView.self
    }

    func loadItem() -> CIModelItem {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "name == %@", itemName)
        let itemsWithName = realm.objects(CIModelItem.self).filter(predicate)
        return itemsWithName[0]
    }
    
    func xValues(selectedButtonIndex:Int) -> [String] {
        let formatter = NSDateFormatter()
        if selectedButtonIndex == 0 {
            return formatter.weekdaySymbols
        }
        else {
            return formatter.shortMonthSymbols
        }
    }
    
    func yValue(atXLabel xLabel:String, selectedButtonIndex:Int) -> Double? {
        let index = xValues(selectedButtonIndex).indexOf(xLabel)!
        let component = selectedButtonIndex == 0 ? NSCalendarUnit.Weekday : NSCalendarUnit.Month
        let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
        let item = loadItem()
        
        var total:Double = 0.0
        for entry in item.entries {
            let component = calendar.component(component, fromDate: entry.startDate)
            if ((component - 1) == index) {
                total += entry.time
            }
        }
        return total
    }
    
    func loadChartData(chart: ChartViewBase, selectedButtonIndex:Int) {
        let xValues = self.xValues(selectedButtonIndex)
        var dataEntries:[BarChartDataEntry] = []
        for i in 0..<xValues.count {
            let value = yValue(atXLabel: xValues[i], selectedButtonIndex: selectedButtonIndex)
            dataEntries.append(BarChartDataEntry(value: value!, xIndex: i))
        }
        
        let dataSet = BarChartDataSet(yVals: dataEntries, label: "")
        dataSet.colors = [UIColor.whiteColor().colorWithAlphaComponent(0.6)]
        dataSet.drawValuesEnabled = false
        dataSet.highlightColor = UIColor.whiteColor()
        dataSet.highlightLineWidth = 10
        dataSet.highlightAlpha = 0.5
        dataSet.highlightEnabled = true
        
        let data = BarChartData(xVals: xValues, dataSet: dataSet)
        
        (chart as! BarChartView).leftAxis.axisMaxValue = max(10.0, ceil(data.yMax))
        
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
        barChart.leftAxis.granularity = 1.0
        barChart.leftAxis.axisMinValue = 0
        
        barChart.xAxis.labelFont = .CIChartAxisLabelFont
        barChart.xAxis.labelTextColor = .whiteColor()
        barChart.xAxis.labelPosition = .Bottom
        barChart.xAxis.axisLineColor = .whiteColor()
        barChart.xAxis.axisLineWidth = 2.0
        barChart.xAxis.gridLineWidth = 0.0
    }
    
    func setAxisLabels(chart: ChartViewBase) {
        let barChart = chart as! BarChartView
        if barChart.leftAxis.labelCount > Int(barChart.chartYMax) {
            barChart.leftAxis.setLabelCount(Int(barChart.chartYMax) + 1, force: true)
        }
    }
    
    func chartTitle(selectedButtonIndex: Int) -> String {
        return (selectedButtonIndex == 0) ? "Clocked Time by Weekday".localized : "Clocked Time by Month".localized
    }
    
    func formatSelectedValues(xValue: String, yValue: Double, selectedButtonIndex: Int) -> (String, String) {
        var xString = xValue
        if selectedButtonIndex == 1 {
            let xIndex = xValues(1).indexOf(xValue)!
            xString = NSDateFormatter().monthSymbols[xIndex]
        }
        else {
            xString = xString.stringByAppendingString("S")
        }
        return (xString.uppercaseString, NSDate.longStringForInterval(Int(yValue)).uppercaseString)
    }
}