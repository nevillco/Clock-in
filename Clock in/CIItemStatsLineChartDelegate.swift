//
//  CILineGraphDelegate.swift
//  Clock in
//
//  Created by Connor Neville on 6/13/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import Charts
import RealmSwift

class CIItemStatsLineChartDelegate: CIItemStatsChartDelegate {
    let formatter = NSDateFormatter()
    let itemName: String
    
    required init(itemName: String) {
        formatter.dateFormat = "M/dd/yy"
        self.itemName = itemName
    }
    
    func controlNames() -> [String] {
        return ["default".localized, "cumulative".localized]
    }
    
    func chartType() -> ChartViewBase.Type {
        return LineChartView.self
    }
    
    func loadItem() -> CIModelItem {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "name == %@", itemName)
        let itemsWithName = realm.objects(CIModelItem.self).filter(predicate)
        return itemsWithName[0]
    }
    
    func xValues(selectedButtonIndex:Int) -> [String] {
        formatter.dateFormat = "M/dd/yy"
        let item = loadItem()
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
        let item = loadItem()
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
        dataSet.circleRadius = 2.0
        dataSet.lineWidth = 1.0
        dataSet.colors = [UIColor.whiteColor()]
        dataSet.drawValuesEnabled = false
        dataSet.highlightEnabled = true
        dataSet.highlightColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        dataSet.highlightLineWidth = 2.0
        
        let data = LineChartData(xVals: xValues, dataSet: dataSet)
        
        (chart as! LineChartView).leftAxis.axisMaxValue = max(10.0, ceil(data.yMax))
        
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
        lineChart.leftAxis.granularity = 1.0
        
        lineChart.xAxis.labelFont = .CIChartAxisLabelFont
        lineChart.xAxis.labelTextColor = .whiteColor()
        lineChart.xAxis.labelPosition = .Bottom
        lineChart.xAxis.axisLineColor = .whiteColor()
        lineChart.xAxis.axisLineWidth = 2.0
        lineChart.xAxis.gridLineWidth = 0.0
    }
    
    func setAxisLabels(chart: ChartViewBase) {
        let lineChart = chart as! LineChartView
        if lineChart.leftAxis.labelCount > Int(lineChart.chartYMax) {
            lineChart.leftAxis.setLabelCount(Int(lineChart.chartYMax) + 1, force: true)
        }
    }
    
    func chartTitle(selectedButtonIndex: Int) -> String {
        return "Clocked Time by Day".localized
    }
    
    func formatSelectedValues(xValue: String, yValue: Double, selectedButtonIndex: Int) -> (String, String) {
        formatter.dateFormat = "M/dd/yy"
        let xDate = formatter.dateFromString(xValue)!
        formatter.dateFormat = "MMMM d"
        return (formatter.stringFromDate(xDate).uppercaseString, NSDate.longStringForInterval(Int(yValue)).uppercaseString)
    }
}