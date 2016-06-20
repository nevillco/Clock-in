//
//  CIGlobalStatsChartDelegate.swift
//  Clock-in
//
//  Created by Connor Neville on 6/20/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import Charts

protocol CIGlobalStatsChartDelegate {
    func chartType() -> ChartViewBase.Type
    
    func xValues(selectedItems:[CIModelItem]) -> [String]
    func yValue(atXLabel xLabel:String, selectedItem:CIModelItem) -> Double
    func loadChartData(chart: ChartViewBase, selectedItems:[CIModelItem])
    func setAxisLabels(chart: ChartViewBase)
    
    func styleChart(chart:ChartViewBase)
    func chartTitle() -> String
    func formatSelectedValues(xValue: String, yValue: Double, selectedItem: CIModelItem) -> (String, String)
}