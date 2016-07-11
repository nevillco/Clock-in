//
//  CIGlobalStatsBubbleChartDelegate.swift
//  Clock-in
//
//  Created by Connor Neville on 6/20/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import Charts
import RealmSwift

class CIGlobalStatsBubbleChartDelegate: CIGlobalStatsChartDelegate {
    let formatter = NSDateFormatter()
    func chartType() -> ChartViewBase.Type {
        return BubbleChartView.self
    }
    
    func xValues(selectedItems:[CIModelItem]) -> [String] {
        let startDate:NSDate = selectedItems.map({ $0.createDate }).sort({ $0.compare($1) == .OrderedAscending })[0]
        let endDates:[NSDate] = selectedItems.map({ $0.entries.sorted("startDate", ascending: false).first!.startDate })
        let maxEndDate = endDates.sort({ $0.compare($1) == .OrderedDescending })[0]
        formatter.dateFormat = "M/dd/yy"
        var currentDate = startDate.roundToDay()
        var xValues:[String] = []
        while(currentDate.timeIntervalSinceDate(maxEndDate) <= 0.0 || xValues.count < 7) {
            xValues.append(formatter.stringFromDate(currentDate))
            currentDate = currentDate.advancedByDays(1)
        }
        return xValues
    }
    
    func yValue(atXLabel xLabel:String, selectedItem:CIModelItem) -> Double? {
        return 0
    }
    
    func yValueAndSize(atXLabel xLabel:String, selectedItem:CIModelItem) -> (total:Double, clocks:Double) {
        formatter.dateFormat = "M/dd/yy"
        var total = 0.0
        var clocks = 0.0
        for entry in selectedItem.entries {
            let dateToCompare = formatter.dateFromString(xLabel)!.roundToDay()
            let entryDate = entry.startDate.roundToDay()
            if entryDate.sameDay(dateToCompare) {
                total += entry.time
                clocks += 1
            }
        }
        return (total, clocks)
    }
    
    func loadChartData(chart: ChartViewBase, selectedItems: [CIModelItem]) {
        let xValues = self.xValues(selectedItems)
        let data = BubbleChartData(xVals: xValues)
        for item in selectedItems {
            var dataEntries:[BubbleChartDataEntry] = []
            for i in 0..<xValues.count {
                let xLabel = xValues[i]
                let (total, clocks) = yValueAndSize(atXLabel: xLabel, selectedItem: item)
                dataEntries.append(BubbleChartDataEntry(xIndex: i, value: total, size: CGFloat(clocks)))
            }
            
            let dataSet = BubbleChartDataSet(yVals: dataEntries)
            dataSet.normalizeSizeEnabled = true
            
            dataSet.colors = [UIColor.colorForItem(item)]
            dataSet.drawValuesEnabled = false
            dataSet.highlightEnabled = true
            dataSet.highlightColor = UIColor.colorForItem(item).colorWithAlphaComponent(0.8)
            dataSet.highlightLineWidth = 1.0
            
            data.addDataSet(dataSet)
        }
        (chart as! BubbleChartView).leftAxis.axisMaxValue = max(10.0, ceil(data.yMax * 1.25))
        chart.data = data
    }
    
    func setAxisLabels(chart: ChartViewBase) {
        let bubbleChart = chart as! BubbleChartView
        if bubbleChart.leftAxis.labelCount > Int(bubbleChart.chartYMax) {
            bubbleChart.leftAxis.setLabelCount(Int(bubbleChart.chartYMax) + 1, force: true)
        }
    }
    
    func styleChart(chart: ChartViewBase) {
        let bubbleChart = chart as! BubbleChartView
        bubbleChart.descriptionText = ""
        bubbleChart.extraTopOffset = CIConstants.chartTopOffset
        bubbleChart.extraRightOffset = CIConstants.chartRightOffset
        bubbleChart.extraLeftOffset = CIConstants.chartLeftOffset
        
        bubbleChart.legend.enabled = false
        
        bubbleChart.rightAxis.enabled = false
        
        bubbleChart.leftAxis.labelFont = .CIChartAxisLabelFont
        bubbleChart.leftAxis.labelTextColor = .blackColor()
        bubbleChart.leftAxis.gridColor = .blackColor()
        bubbleChart.leftAxis.axisLineColor = .blackColor()
        bubbleChart.leftAxis.axisLineWidth = 2.0
        bubbleChart.leftAxis.valueFormatter = CIChartIntervalFormatter()
        bubbleChart.leftAxis.axisMinValue = 0
        bubbleChart.leftAxis.granularity = 1.0
        
        bubbleChart.xAxis.labelFont = .CIChartAxisLabelFont
        bubbleChart.xAxis.labelTextColor = .blackColor()
        bubbleChart.xAxis.labelPosition = .Bottom
        bubbleChart.xAxis.axisLineColor = .blackColor()
        bubbleChart.xAxis.axisLineWidth = 2.0
        bubbleChart.xAxis.gridLineWidth = 0.0
    }
    
    func chartTitle() -> String {
        return "Total Time Versus Clocks (Bubble Size)".localized
    }
    
    func formatSelectedValues(xValue: String, yValue: Double, selectedItem: CIModelItem) -> (String, String) {
        formatter.dateFormat = "M/dd/yy"
        let xDate = formatter.dateFromString(xValue)!
        formatter.dateFormat = "MMMM d"
        let xString = String(format: "%@ - %@", formatter.stringFromDate(xDate).uppercaseString, selectedItem.name.uppercaseString)
        let (total, clocks) = self.yValueAndSize(atXLabel: xValue, selectedItem: selectedItem)
        let yString = String(format:"%d CLOCK%@ TOTALING %@", Int(clocks), (Int(clocks) == 1) ? "" : "S", NSDate.stringForInterval(Int(total)))
        return (xString, yString)
    }
}