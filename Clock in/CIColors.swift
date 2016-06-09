//
//  CIColors.swift
//  Clock in
//
//  Created by Connor Neville on 6/8/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit

extension UIColor {
    static func CIStatsColors() -> [UIColor] {
        return [
            CIBlue,                                                             //blue
            UIColor(red: 219/255, green: 84/255, blue: 68/255, alpha: 1),       //red
            UIColor(red: 229/255, green: 229/255, blue: 80/255, alpha: 1),      //yellow
            UIColor(red: 160/255, green: 34/255, blue: 240/255, alpha:1),       //purple
            UIColor(red: 234/255, green: 155/255, blue: 0/255, alpha:1),        //orange
            UIColor(red: 64/255, green: 219/255, blue: 219/255, alpha: 1),      //cyan
            UIColor(red: 255/255, green: 192/255, blue: 205/255, alpha:1),      //pink
            UIColor(red: 152/255, green: 152/255, blue: 152/255, alpha:1),      //silver
            UIColor(red: 255/255, green: 200/255, blue: 0/255, alpha:1),        //gold
            UIColor(red: 109/255, green: 242/255, blue: 109/255, alpha:1),      //light green
            UIColor(red: 255/255, green: 255/255, blue: 255, alpha:1),          //white
            UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha:1),]           //black
    }
    @nonobjc static let CIBlue: UIColor = UIColor(red: 0, green: 118/255, blue: 1, alpha: 1)
    @nonobjc static let CIGreen: UIColor = UIColor(red: 68/255, green: 219/255, blue: 84/255, alpha: 1)
    @nonobjc static let CIGray: UIColor = UIColor(red: 157/255, green:157/255, blue: 152/255, alpha:1)
}
