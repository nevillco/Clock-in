//
//  CIModelItem.swift
//  Clock in
//
//  Created by Connor Neville on 6/9/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import RealmSwift

class CIModelItem: Object {
    dynamic var name = ""
    dynamic var createDate = NSDate()
    let entries = List<CIModelEntry>()
    
    override static func indexedProperties() -> [String] {
        return ["name"]
    }
    
    override static func primaryKey() -> String? {
        return "name"
    }
}