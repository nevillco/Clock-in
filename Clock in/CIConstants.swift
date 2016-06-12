//
//  CIConstants.swift
//  Clock in
//
//  Created by Connor Neville on 6/8/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit

class CIConstants {
    static let paddingFromTop:CGFloat = 30
    static let horizontalItemSpacing:CGFloat = 8
    static let verticalItemSpacing:CGFloat = 7
    static let buttonWidth:CGFloat = 91
    static let buttonWidthWide:CGFloat = 145
    
    static let homeCellRowHeight:CGFloat = 81
    static let settingsCellRowHeight:CGFloat = 39
    
    static let itemMaxChars = 18
    static let charsRemainingForWarning = 5
    static let maxItems = UIColor.CIColorPalette.count
    
    static let notificationIntervals:[Int] = [
        60*5,
        60*30,
        60*60,
        120*60]
}
