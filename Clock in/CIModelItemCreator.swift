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
        
        try! realm.write {
            realm.add(item, update: false)
        }
    }
    
    static func rename(item:CIModelItem, toName:String) {
        let realm = try! Realm()
        try! realm.write {
            item.name = toName
        }
    }
}