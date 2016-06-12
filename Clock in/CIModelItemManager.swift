//
//  CIModelItemManager.swift
//  Clock in
//
//  Created by Connor Neville on 6/11/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import RealmSwift

class CIModelItemManager {
    let item: CIModelItem
    var clockedIn = false
    var lastClockIn: NSDate? = nil
    
    init(item: CIModelItem) {
        self.item = item
    }
    
    func clockIn() {
        clockedIn = true
        lastClockIn = NSDate()
    }
    
    func clockOut() {
        let interval = NSDate().timeIntervalSinceDate(lastClockIn!)
        let newEntry = CIModelEntry()
        newEntry.startDate = lastClockIn!
        newEntry.time = interval
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(newEntry)
            item.entries.append(newEntry)
        }
        
        lastClockIn = nil
        clockedIn = false
    }
    
    func cancelClockIn() {
        lastClockIn = nil
        clockedIn = false
    }
}
