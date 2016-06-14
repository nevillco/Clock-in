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
    var rewindTime: NSTimeInterval = 0.0
    
    init(item: CIModelItem) {
        self.item = item
    }
    
    func clockIn() {
        clockedIn = true
        lastClockIn = NSDate()
        scheduleNotifications()
    }
    
    func clockOut() {
        let newEntry = CIModelEntry()
        newEntry.startDate = lastClockIn!
        newEntry.time = currentClockTime()
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(newEntry)
            item.entries.append(newEntry)
        }
        
        lastClockIn = nil
        clockedIn = false
        cancelNotifications()
    }
    
    func cancelClockIn() {
        lastClockIn = nil
        clockedIn = false
        cancelNotifications()
    }
    
    private func scheduleNotifications() {
        item.notificationIntervals.forEach({doubleObj in
            let notification = UILocalNotification()
            let bodyText = String(format: "You've been clocked in to %@ for %@.", item.name, NSDate.longStringForInterval(Int(doubleObj.value)))
            notification.alertBody = bodyText
            notification.fireDate = NSDate().dateByAddingTimeInterval(doubleObj.value) // todo item due date (when notification will be fired)
            notification.category = item.name
            UIApplication.sharedApplication().scheduleLocalNotification(notification)
        })
    }
    
    private func cancelNotifications() {
        let app = UIApplication.sharedApplication()
        for notification in app.scheduledLocalNotifications! {
            if notification.category! == item.name {
                app.cancelLocalNotification(notification)
            }
        }
    }
    
    func currentClockTime() -> NSTimeInterval {
        return NSDate().timeIntervalSinceDate(lastClockIn!) - rewindTime
    }
}
