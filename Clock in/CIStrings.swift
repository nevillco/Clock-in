//
//  CIStrings.swift
//  Clock in
//
//  Created by Connor Neville on 6/8/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation

extension String {
    var localized: String { return NSLocalizedString(self, comment: "") }
    
    static let CIDefaultNotificationsOn = "NotificationsOn"
    static let CIDefaultNotificationIntervals = "NotificationIntervals"
    static let CIDefaultAlertForcedClockOut = "AlertForcedClockOut"
    static let CIHasWrittenDefaults = "HasWrittenDefaults"
    
    static let CIHomeCellReuseIdentifier = "HomeCell"
    static let CISettingsCellReuseIdentifier = "SettingsCell"
    static let CIDefaultCollectionCellReuseIdentifier = "DefaultCollectionCell"
    static let CIStatsCellReuseIdentifier = "StatsCell"
}
