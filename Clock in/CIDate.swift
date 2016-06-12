//
//  CIDate.swift
//  Clock in
//
//  Created by Connor Neville on 6/12/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

import Foundation
extension NSDate {
    class func stringForInterval(interval:Int) -> String {
        let days = interval / (3600 * 24)
        let hours = (interval / 3600) % 24
        let minutes = (interval / 60) % 60
        let seconds = interval % 60
        
        if(days > 0) {
            if(hours == 0) { return String(format: "%dd", days) }
            return String(format: "%dd%dh", days, hours)
        }
        else if hours > 0 {
            if minutes == 0 { return String(format:"%dh", hours) }
            return String(format: "%dh%dm", hours, minutes)
        }
        else if minutes > 0 {
            return String(format: "%dm", minutes)
        }
        return String(format: "%ds", seconds)
    }
    
    class func longStringForInterval(interval:Int) -> String {
        let days = interval / (3600 * 24)
        let hours = interval / 3600
        let minutes = (interval / 60) % 60
        let seconds = interval % 60
        
        if(days > 0) {
            if(days == 1) {
                if(hours == 0) { return "1 day" }
                return String(format: "1 day, %d hours", hours)
            }
            else {
                if(hours == 0) { return String(format: "%d days", days) }
                return String(format: "%d days, %d hours", days, hours)
            }
        }
        else if hours > 0 {
            if hours == 1 {
                if minutes == 0 { return "1 hour" }
                return String(format: "1 hour, %d minutes", minutes)
            }
            else {
                if minutes == 0 { return String(format:"%d hours", hours) }
                return String(format: "%d hours, %d minutes", hours, minutes)
            }
        }
        else if minutes > 0 {
            if minutes == 1 {
                if seconds == 0 { return "1 minute" }
                return String(format: "1 minute, %d seconds", seconds)
            }
            else {
                if seconds == 0 {return String(format: "%d minutes", minutes) }
                return String(format: "%d minutes, %d seconds", minutes, seconds)
            }
        }
        if seconds == 1 { return "1 second" }
        return String(format: "%d seconds", seconds)
    }
    
    func sameDay(other: NSDate) -> Bool {
        let calendar = NSCalendar.currentCalendar()
        return calendar.component([.Day], fromDate: self) == calendar.component([.Day], fromDate: other)
    }
    
    func roundToDay() -> NSDate {
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        
        let components = calendar.components([.Year, .Month, .Day], fromDate: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        
        return calendar.dateFromComponents(components)!
    }
    
    func advancedByDays(days:Int) -> NSDate {
        return self.dateByAddingTimeInterval(NSTimeInterval(60*60*24*days))
    }
}