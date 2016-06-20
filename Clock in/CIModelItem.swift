//
//  CIModelItem.swift
//  Clock in
//
//  Created by Connor Neville on 6/9/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import RealmSwift
import Foundation

class CIModelItem: Object {
    dynamic var name = ""
    dynamic var createDate = NSDate()
    let entries = List<CIModelEntry>()
    let notificationIntervals = List<CIDoubleObject>()
    dynamic var colorIndex = 0
    dynamic var clockedIn = false
    dynamic var lastClockIn:NSDate? = nil
    dynamic var adjustTime:Double = 0.0
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
}

class CIDoubleObject: Object {
    dynamic var value:Double = 0.0
}