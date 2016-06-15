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
    static let cornerRadius:CGFloat = 6
    static let borderWidth:CGFloat = 2
    
    static let homeCellRowHeight:CGFloat = 81
    static let settingsHeaderHeight:CGFloat = 49
    static let settingsCellRowHeight:CGFloat = 39
    
    static let itemMaxChars = 18
    static let charsRemainingForWarning = 5
    static let maxItems = UIColor.CIColorPalette.count
    
    static let maxNotifications = 8
    static let notificationIntervals:[NSTimeInterval] = [
        60*15,
        60*30,
        60*60,
        60*120]
    
    static let pageControlHeight:CGFloat = 40.0
    static let chartLeftOffset:CGFloat = 8.0
    static let chartRightOffset:CGFloat = 35.0
    static let chartLabelSpacing:CGFloat = 14.0
}
