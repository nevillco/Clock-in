//
//  CIColors.swift
//  Clock in
//
//  Created by Connor Neville on 6/8/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit
import RealmSwift

extension UIColor {
    @nonobjc static let CIColorPalette:[UIColor] = [
        CIBlue,
        CIRed,
        CIDarkGreen,
        CIPurple,
        CIOrange,
        CICyan,
        CIPink,
        CISilver,
        CIYellow,
        CIBlack]
    
    @nonobjc static let CIBlue = UIColor(red: 0, green: 118/255, blue: 1, alpha: 1)
    @nonobjc static let CIRed = UIColor(red: 219/255, green: 84/255, blue: 68/255, alpha: 1)
    @nonobjc static let CIGreen = UIColor(red: 68/255, green: 219/255, blue: 84/255, alpha: 1)
    @nonobjc static let CIDarkGreen = UIColor(red: 20/255, green: 170/255, blue: 33/255, alpha: 1)
    @nonobjc static let CIGray = UIColor(red: 157/255, green:157/255, blue: 152/255, alpha: 1)
    @nonobjc static let CIYellow = UIColor(red: 229/255, green: 229/255, blue: 100/255, alpha: 1)
    @nonobjc static let CIPurple = UIColor(red: 160/255, green: 34/255, blue: 240/255, alpha: 1)
    @nonobjc static let CIOrange = UIColor(red: 234/255, green: 155/255, blue: 0/255, alpha: 1)
    @nonobjc static let CICyan = UIColor(red: 64/255, green: 219/255, blue: 219/255, alpha: 1)
    @nonobjc static let CIPink = UIColor(red: 255/255, green: 192/255, blue: 205/255, alpha: 1)
    @nonobjc static let CISilver = UIColor(red: 152/255, green: 152/255, blue: 152/255, alpha: 1)
    @nonobjc static let CIBlack = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1)
    
    static func CIAvailableColors() -> [UIColor] {
        let realm = try! Realm()
        let modelItems = realm.objects(CIModelItem.self)
        var colors = CIColorPalette
        for modelItem in modelItems {
            let color = NSKeyedUnarchiver.unarchiveObjectWithData(modelItem.colorData) as! UIColor
            colors.removeAtIndex(colors.indexOf(color)!)
        }
        return colors
    }
}
