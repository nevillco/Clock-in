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
    let entries = List<CIModelEntry>()
}