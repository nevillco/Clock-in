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
    let realm: Realm
    
    init(item: CIModelItem) {
        self.item = item
        self.realm = try! Realm()
    }
    
    func clockIn() {
        try! realm.write {
            item.clockedIn = true
            item.lastClockIn = NSDate()
        }
        scheduleNotifications()
        adjustBadgeNumber(1)
    }
    
    func clockOut() {
        let newEntries = generateEntries(NSDate().dateByAddingTimeInterval(item.adjustTime), firstRun: true)
        let realm = try! Realm()
        try! realm.write {
            for newEntry in newEntries {
                item.entries.append(newEntry)
            }
            item.lastClockIn = nil
            item.clockedIn = false
            item.adjustTime = 0
        }
        cancelNotifications()
        adjustBadgeNumber(-1)
    }
    
    func cancelClockIn() {
        try! realm.write {
            item.lastClockIn = nil
            item.clockedIn = false
            item.adjustTime = 0
        }
        cancelNotifications()
        adjustBadgeNumber(-1)
    }

    func currentClockTime() -> NSTimeInterval {
        return NSDate().timeIntervalSinceDate(item.lastClockIn!) + item.adjustTime
    }
    
    func fastForward(interval: NSTimeInterval) {
        try! realm.write {
            item.lastClockIn = item.lastClockIn?.dateByAddingTimeInterval(-interval)
        }
        cancelNotifications()
        scheduleNotifications()
    }
    
    func rewind(interval: NSTimeInterval) {
        try! realm.write {
            item.adjustTime -= interval
        }
        cancelNotifications()
        scheduleNotifications()
    }
    
    private func scheduleNotifications() {
        item.notificationIntervals.forEach({doubleObj in
            let interval = doubleObj.value - currentClockTime()
            let notification = UILocalNotification()
            let bodyText = String(format: "You've been clocked in to %@ for %@.", item.name, NSDate.longStringForInterval(Int(doubleObj.value)))
            notification.alertBody = bodyText
            notification.fireDate = NSDate().dateByAddingTimeInterval(interval)
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
    
    private func adjustBadgeNumber(amount: Int) {
        let app = UIApplication.sharedApplication()
        app.applicationIconBadgeNumber += amount
    }
    
    private func generateEntries(targetDate:NSDate, firstRun:Bool) -> [CIModelEntry] {
        if targetDate.sameDay(item.lastClockIn!) {
            let newEntry = CIModelEntry()
            newEntry.startDate = item.lastClockIn!
            newEntry.time = targetDate.timeIntervalSinceDate(item.lastClockIn!)
            return [newEntry]
        }
        else {
            var targetDateShifted = targetDate.roundToDay()
            if(!firstRun) { targetDateShifted = targetDateShifted.advancedByDays(-1) }
            let partialInterval = targetDate.timeIntervalSinceDate(targetDateShifted)
            let newEntry = CIModelEntry()
            newEntry.startDate = targetDateShifted
            newEntry.time = partialInterval
            var entries = [newEntry]
            entries.appendContentsOf(generateEntries(targetDateShifted, firstRun:false))
            return entries
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
