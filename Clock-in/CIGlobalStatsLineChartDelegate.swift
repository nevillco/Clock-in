//
//  CIGlobalStatsLineChartDelegate.swift
//  Clock-in
//
//  Created by Connor Neville on 6/20/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import Charts
import RealmSwift

class CIGlobalStatsLineChartDelegate: CIGlobalStatsChartDelegate {
    let formatter = NSDateFormatter()
    func chartType() -> ChartViewBase.Type {
        return LineChartView.self
    }
    
    func xValues(selectedItems:[CIModelItem]) -> [String] {
        let startDate:NSDate = selectedItems.map({ $0.createDate }).sort({ $0.compare($1) == .OrderedAscending })[0]
        let endDates:[NSDate] = selectedItems.map({ $0.entries.sorted("startDate", ascending: false).first!.startDate })
        let maxEndDate = endDates.sort({ $0.compare($1) == .OrderedDescending })[0]
        formatter.dateFormat = "M/dd/yy"
        var currentDate = startDate.roundToDay()
        var xValues:[String] = []
        while(currentDate.timeIntervalSinceDate(maxEndDate) <= 0.0) {
            xValues.append(formatter.stringFromDate(currentDate))
            currentDate = currentDate.advancedByDays(1)
        }
        return xValues
    }
    
    func yValue(atXLabel xLabel:String, selectedItem:CIModelItem) -> Double? {
        formatter.dateFormat = "M/dd/yy"
        var total = 0.0
        for entry in selectedItem.entries {
            let dateToCompare = formatter.dateFromString(xLabel)!.roundToDay()
            let entryDate = entry.startDate.roundToDay()
            if entryDate.sameDay(dateToCompare) {
                total += entry.time
            }
        }
        return (total > 0.0) ? total : nil
        
    }
    
    func loadChartData(chart: ChartViewBase, selectedItems: [CIModelItem]) {
        let xValues = self.xValues(selectedItems)
        let data = LineChartData(xVals: xValues)
        var dataEntries:[ChartDataEntry] = []
        for item in selectedItems {
            for i in 0..<xValues.count {
                if let value = yValue(atXLabel: xValues[i], selectedItem: item) {
                    dataEntries.append(ChartDataEntry(value: value, xIndex: i))
                }
                else {
                    let dataSet = LineChartDataSet(yVals: dataEntries, label: "")
                    dataSet.circleColors = [UIColor.colorForItem(item)]
                    dataSet.circleRadius = 3.0
                    dataSet.lineWidth = 1.5
                    dataSet.colors = [UIColor.colorForItem(item)]
                    dataSet.drawValuesEnabled = false
                    dataSet.highlightEnabled = true
                    dataSet.highlightColor = UIColor.colorForItem(item).colorWithAlphaComponent(0.5)
                    dataSet.highlightLineWidth = 2.0
                    data.addDataSet(dataSet)
                    dataEntries = []
                }
            }
            if dataEntries.count > 0 {
                let dataSet = LineChartDataSet(yVals: dataEntries, label: "")
                dataSet.circleColors = [UIColor.colorForItem(item)]
                dataSet.circleRadius = 3.0
                dataSet.lineWidth = 1.5
                dataSet.colors = [UIColor.colorForItem(item)]
                dataSet.drawValuesEnabled = false
                dataSet.highlightEnabled = true
                dataSet.highlightColor = UIColor.colorForItem(item).colorWithAlphaComponent(0.5)
                dataSet.highlightLineWidth = 2.0
                data.addDataSet(dataSet)
            }
        }
        (chart as! LineChartView).leftAxis.axisMaxValue = max(10.0, ceil(data.yMax))
        
        chart.data = data
    }
    
    func setAxisLabels(chart: ChartViewBase) {
        let lineChart = chart as! LineChartView
        if lineChart.leftAxis.labelCount > Int(lineChart.chartYMax) {
            lineChart.leftAxis.setLabelCount(Int(lineChart.chartYMax) + 1, force: true)
        }
    }
    
    func styleChart(chart: ChartViewBase) {
        let lineChart = chart as! LineChartView
        lineChart.descriptionText = ""
        lineChart.extraTopOffset = CIConstants.chartTopOffset
        lineChart.extraRightOffset = CIConstants.chartRightOffset
        lineChart.extraLeftOffset = CIConstants.chartLeftOffset
        
        lineChart.legend.enabled = false
        
        lineChart.rightAxis.enabled = false
        
        lineChart.leftAxis.labelFont = .CIChartAxisLabelFont
        lineChart.leftAxis.labelTextColor = .blackColor()
        lineChart.leftAxis.gridColor = .blackColor()
        lineChart.leftAxis.axisLineColor = .blackColor()
        lineChart.leftAxis.axisLineWidth = 2.0
        lineChart.leftAxis.valueFormatter = CIChartIntervalFormatter()
        lineChart.leftAxis.axisMinValue = 0
        lineChart.leftAxis.granularity = 1.0
        
        lineChart.xAxis.labelFont = .CIChartAxisLabelFont
        lineChart.xAxis.labelTextColor = .blackColor()
        lineChart.xAxis.labelPosition = .Bottom
        lineChart.xAxis.axisLineColor = .blackColor()
        lineChart.xAxis.axisLineWidth = 2.0
        lineChart.xAxis.gridLineWidth = 0.0
    }
    
    func chartTitle() -> String {
        return "Clocked Time by Day".localized
    }
    
    func formatSelectedValues(xValue: String, yValue: Double, selectedItem: CIModelItem) -> (String, String) {
        formatter.dateFormat = "M/dd/yy"
        let xDate = formatter.dateFromString(xValue)!
        formatter.dateFormat = "MMMM d"
        let xString = String(format: "%@ - %@", formatter.stringFromDate(xDate).uppercaseString, selectedItem.name.uppercaseString)
        return (xString, NSDate.longStringForInterval(Int(yValue)).uppercaseString)
    }
}