//
//  CIModelItemManager.swift
//  Clock in
//
//  Created by Connor Neville on 6/11/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation

class CIModelItemManager {
    let item: CIModelItem
    var clockedIn = false
    var lastClockIn: NSDate? = nil
    
    init(item: CIModelItem) {
        self.item = item
    }
}
