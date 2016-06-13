//
//  CILineGraphDelegate.swift
//  Clock in
//
//  Created by Connor Neville on 6/13/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation

class CILineGraphDelegate: CIStatsChartDelegate {
    func controlNames() -> [String] {
        return ["default".localized, "cumulative".localized]
    }
}