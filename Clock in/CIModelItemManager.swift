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
    var adjustTime: NSTimeInterval = 0.0
    
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

    func currentClockTime() -> NSTimeInterval {
        return NSDate().timeIntervalSinceDate(lastClockIn!) + adjustTime
    }
    
    func colorForItem() -> UIColor {
        return UIColor.CIColorPalette[item.colorIndex]
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
    
    static func CIAvailableColors() -> [UIColor] {
        let realm = try! Realm()
        let modelItems = realm.objects(CIModelItem.self)
        var colors = UIColor.CIColorPalette
        var takenIndices:[Int] = modelItems.map({ $0.colorIndex })
        takenIndices.sortInPlace({ $1 < $0 })
        for index in takenIndices {
            colors.removeAtIndex(index)
        }
        return colors
    }
}
