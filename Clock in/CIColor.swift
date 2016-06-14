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
        CICyan,
        CIGreen,
        CIYellow,
        CIOrange,
        CIRed,
        CIPurple,
        CIGray,
        CIBlack]
    
    @nonobjc static let CIBlue = UIColor(red:0.18, green:0.29, blue:0.98, alpha:1.00)
    @nonobjc static let CICyan = UIColor(red:0.20, green:0.79, blue:0.98, alpha:1.00)
    @nonobjc static let CIGreen = UIColor(red:0.00, green:0.62, blue:0.27, alpha:1.00)
    @nonobjc static let CIYellow = UIColor(red:0.85, green:0.82, blue:0.29, alpha:1.00)
    @nonobjc static let CIOrange = UIColor(red:0.91, green:0.50, blue:0.16, alpha:1.00)
    @nonobjc static let CIRed = UIColor(red:0.83, green:0.13, blue:0.13, alpha:1.00)
    @nonobjc static let CIPurple = UIColor(red:0.69, green:0.25, blue:0.80, alpha:1.00)
    @nonobjc static let CIGray = UIColor(red:0.59, green:0.59, blue:0.59, alpha:1.00)
    @nonobjc static let CIBlack = UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.00)
}
