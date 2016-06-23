//
//  CIConstants.swift
//  Clock in
//
//  Created by Connor Neville on 6/8/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit

class CIConstants {
    private static func isPortrait() -> Bool { return UIApplication.sharedApplication().statusBarOrientation.isPortrait }
    private static func isiPhone() -> Bool { return UIDevice.currentDevice().userInterfaceIdiom == .Phone }
    
    static func paddingFromTop() -> CGFloat {
        return isPortrait() ? 30 : 9
    }
    static let horizontalItemSpacing:CGFloat = 8
    static let verticalItemSpacing:CGFloat = 7
    
    static func buttonWidth() -> CGFloat {
        return isiPhone() ? 91 : 146
    }
    static func buttonWidthWide() -> CGFloat {
        return isiPhone() ? 145 : 212
    }
    static func cornerRadius() -> CGFloat {
        return isiPhone() ? 6 : 8
    }
    static func borderWidth() -> CGFloat {
        return isiPhone() ? 2 : 3
    }
    
    static let homeCellRowHeight:CGFloat = 85
    static let settingsHeaderHeight:CGFloat = 49
    static let settingsCellRowHeight:CGFloat = 39
    static let statsCellHeaderHeight:CGFloat = 30
    static func statsCellRowHeight() -> CGFloat {
        return isiPhone() ? 70 : 90
    }
    
    static let itemMaxChars = 18
    static let charsRemainingForWarning = 5
    static let maxItems = UIColor.CIColorPalette.count
    
    static func colorCollectionCellSize() -> CGSize {
        return isiPhone() ? CGSizeMake(50, 50) : CGSizeMake(120, 120)
    }
    static func colorCollectionLandscapeCellSize() -> CGSize {
        return isiPhone() ? CGSizeMake(35, 35) : CGSizeMake(80, 80)
    }
    
    static let maxNotifications = 8
    static let notificationIntervals:[NSTimeInterval] = [
        60*15,
        60*30,
        60*60,
        60*120]
    
    static let pageControlHeight:CGFloat = 40.0
    static let chartLeftOffset:CGFloat = 8.0
    static let chartRightOffset:CGFloat = 35.0
    static let chartTopOffset:CGFloat = 12.0
    static let chartLabelSpacing:CGFloat = 14.0
    static let maxBubbleSize:CGFloat = 5.0
}
