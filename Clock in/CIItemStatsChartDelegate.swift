//
//  CIGlobalStatsChartDelegate.swift
//  Clock in
//
//  Created by Connor Neville on 6/13/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import Charts

protocol CIItemStatsChartDelegate {
    func controlNames() -> [String]
    func chartType() -> ChartViewBase.Type
    func xValues(selectedButtonIndex:Int) -> [String]
    func yValue(atXLabel xLabel:String, selectedButtonIndex:Int) -> Double
    func loadChartData(chart: ChartViewBase, selectedButtonIndex:Int)
    func styleChart(chart:ChartViewBase)
    func hasSufficientData(selectedButtonIndex:Int) -> Bool
}