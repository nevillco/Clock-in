//
//  CIFontExtension.swift
//  Clock in
//
//  Created by Connor Neville on 6/8/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import UIKit

extension UIFont {
    private static func isiPhone() -> Bool { return UIDevice.currentDevice().userInterfaceIdiom == .Phone }
    
    @nonobjc static func CIDefaultTitleFont() -> UIFont {
        return UIFont(name: "Lato-Hairline", size: isiPhone() ? 40.0 : 60.0)!
    }
    @nonobjc static func CIDefaultBodyFont() -> UIFont {
        return UIFont(name: "Lato-Regular", size: isiPhone() ? 14.0 : 18.0)!
    }
    @nonobjc static func CIBoldBodyFont() -> UIFont {
        return UIFont(name: "Lato-Bold", size: isiPhone() ? 14.0 : 18.0)!
    }
    
    @nonobjc static func CILargeTextButtonFont() -> UIFont {
        return UIFont(name: "Lato-Regular", size: isiPhone() ? 26.0 : 30.0)!
    }
    @nonobjc static func CITextButtonFont() -> UIFont {
        return UIFont(name: "Lato-Regular", size: isiPhone() ? 18.0 : 24.0)!
    }
    @nonobjc static let CITimerTextFont = UIFont(name: "Lato-Bold", size: 18.0)!
    @nonobjc static let CITextFieldFont = UIFont(name: "Lato-Regular", size: 22.0)!
    
    @nonobjc static let CIHomeTitleLightFont = UIFont(name: "Lato-Light", size: 40.0)!
    @nonobjc static let CIHomeTitleRegularFont = UIFont(name: "Lato-Regular", size: 40.0)!
    @nonobjc static let CIHomeCellClockButtonFont = UIFont(name: "Lato-Black", size: 32.0)!
    @nonobjc static let CIHomeCellTextFont = UIFont(name: "Lato-Light", size: 24.0)!
    
    @nonobjc static func CIButtonRegularFont() -> UIFont {
        return UIFont(name: "Lato-Regular", size: isiPhone() ? 16.0 : 22.0)!
    }
    @nonobjc static func CIButtonBoldFont() -> UIFont {
        return UIFont(name: "Lato-Bold", size: isiPhone() ? 16.0 : 22.0)!
    }
    
    @nonobjc static let CIEmptyDataSetTitleFont = UIFont(name: "Lato-Hairline", size: 44.0)!
    @nonobjc static let CIEmptyDataSetBodyFont = UIFont(name: "Lato-Regular", size: 15.0)!
    
    @nonobjc static let CIChartTitleFont = UIFont(name: "Lato-Bold", size: 28.0)!
    @nonobjc static let CIChartAxisLabelFont = UIFont(name: "Lato-Light", size: 13.0)!
    @nonobjc static func CIStatsInfoLabelFont() -> UIFont {
        return UIFont(name: "Oswald-Light", size: isiPhone() ? 18.0 : 24.0)!
    }
    @nonobjc static func CIStatsDataLabelFont() -> UIFont {
        return UIFont(name: "Oswald-Regular", size: isiPhone() ? 32.0 : 40.0)!
    }
    @nonobjc static let CIStatsHeaderFont = UIFont(name: "Lato-Bold", size: 26.0)!
}
