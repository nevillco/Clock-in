//
//  CIGlobalStatsChartDelegate.swift
//  Clock in
//
//  Created by Connor Neville on 6/13/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import Charts

protocol CIStatsChartDelegate {
    func controlNames() -> [String]
    func chartType() -> ChartViewBase.Type
}