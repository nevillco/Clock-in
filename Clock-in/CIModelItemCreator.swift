//
//  CIModelItemCreator.swift
//  Clock in
//
//  Created by Connor Neville on 6/12/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
import RealmSwift

class CIModelItemCreator {
    static func validate(name: String) -> String? {
        let chars = name.characters.count
        if chars == 0 {
            return "Please enter an item name.".localized
        }
        if chars > CIConstants.itemMaxChars {
            return String(format: "Item names can be at most %d characters.", CIConstants.itemMaxChars).localized
        }
        if itemNameExists(name) {
            return "You already have an item with this name. Please try another."
        }
        return nil
    }
    
    static func itemNameExists(name: String) -> Bool {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "name == %@", name)
        let itemsWithName = realm.objects(CIModelItem.self).filter(predicate)
        return itemsWithName.count > 0
    }
    
    static func createItem(name:String, color:UIColor) {
        let realm = try! Realm()
        let item = CIModelItem()
        item.name = name
        item.createDate = NSDate()
        item.colorIndex = UIColor.CIColorPalette.indexOf(color)!
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let intervals = defaults.objectForKey(.CIDefaultNotificationIntervals) as! [NSTimeInterval]
        intervals.forEach{
            let doubleObj = CIDoubleObject()
            doubleObj.value = $0
            item.notificationIntervals.append(doubleObj)
        }
        
        let delegate = UIApplication.sharedApplication().delegate as! CIAppDelegate
        
        try! realm.write {
            if delegate.shouldGenerateTestData && CIModelTestItemProfile.profileNames.contains(name) {
                let profile = CIModelTestItemProfile(profileName: name)
                item.createDate = NSDate().roundToDay().advancedByDays(-(profile.daysToIterate + 1))
                let entries = generateTestData(CIModelTestItemProfile(profileName: name))
                for entry in entries {
                    item.entries.append(entry)
                }
            }
            realm.add(item, update: false)
        }
    }
    
    static func rename(item:CIModelItem, toName:String) {
        let realm = try! Realm()
        try! realm.write {
            item.name = toName
        }
    }
    
    static func generateTestData(profile:CIModelTestItemProfile) -> [CIModelEntry] {
        var entries = [CIModelEntry]()
        
        let startDate = NSDate().roundToDay().advancedByDays(-(profile.daysToIterate))
        let calendar = NSCalendar.currentCalendar()
        
        var currentDate = startDate
        
        for _ in 0..<profile.daysToIterate {
            let isWeekend = (calendar.component(.Weekday, fromDate: currentDate) % 7) <= 1
            let probabilities = isWeekend ? profile.probabilitiesForClocksPerWeekend : profile.probabilitiesForClocksPerWeekday
            
            for _ in 0..<numClocks(probabilities) {
                let newEntry = CIModelEntry()
                
                let randomTimeOffset:NSTimeInterval = doubleInRange(profile.minStartOffset, max: profile.maxStartOffset)
                newEntry.startDate = currentDate.dateByAddingTimeInterval(randomTimeOffset)
                
                let randomTime:NSTimeInterval = doubleInRange(profile.minClockDuration, max: profile.maxClockDuration)
                newEntry.time = randomTime
                entries.append(newEntry)
            }
            currentDate = currentDate.advancedByDays(1)
        }
        return entries
    }
    
    static func doubleInRange(min: UInt32, max:UInt32) -> Double {
        return Double(arc4random_uniform(max - min) + min)
    }
    
    //http://stackoverflow.com/questions/30309556/generate-random-numbers-with-a-given-distribution
    static func numClocks(probabilities: [Double]) -> Int {
        // Sum of all probabilities (so that we don't have to require that the sum is 1.0):
        let sum = probabilities.reduce(0, combine: +)
        // Random number in the range 0.0 <= rnd < sum :
        let rnd = sum * Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)
        // Find the first interval of accumulated probabilities into which `rnd` falls:
        var accum = 0.0
        for (i, p) in probabilities.enumerate() {
            accum += p
            if rnd < accum {
                return i
            }
        }
        // This point might be reached due to floating point inaccuracies:
        return 0
    }
}