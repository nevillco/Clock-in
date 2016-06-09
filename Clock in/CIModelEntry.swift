//
//  CIModelEntry.swift
//  Clock in
//
//  Created by Connor Neville on 6/9/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import RealmSwift

class CIModelEntry: Object {
    dynamic var startDate = NSDate()
    dynamic var time: Double = 0.0
}
