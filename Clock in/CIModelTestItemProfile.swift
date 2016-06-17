//
//  CIModelTestItemProfile.swift
//  Clock in
//
//  Created by Connor Neville on 6/17/16.
//  Copyright © 2016 Connor Neville. All rights reserved.
//

struct CIModelTestItemProfile {
    var minStartOffset:UInt32
    var maxStartOffset:UInt32
    var minClockDuration:UInt32
    var maxClockDuration:UInt32
    var daysToIterate:Int
    var probabilitiesForClocksPerWeekday:[Double]
    var probabilitiesForClocksPerWeekend:[Double]
    
    static let profileNames = ["Work", "Gym", "Reading", "Coding"]
    
    init(minStartOffset:UInt32, maxStartOffset:UInt32, minClockDuration:UInt32, maxClockDuration:UInt32, daysToIterate:Int, probabilitiesForClocksPerWeekday:[Double], probabilitiesForClocksPerWeekend:[Double]) {
        self.minStartOffset = minStartOffset
        self.maxStartOffset = maxStartOffset
        self.minClockDuration = minClockDuration
        self.maxClockDuration = maxClockDuration
        self.daysToIterate = daysToIterate
        self.probabilitiesForClocksPerWeekday = probabilitiesForClocksPerWeekday
        self.probabilitiesForClocksPerWeekend = probabilitiesForClocksPerWeekend
    }
    
    init(profileName:String) {
        if profileName == "Work" {
            self.init(minStartOffset: (60*60*7), maxStartOffset: (60*60*9), minClockDuration: (60*60*7), maxClockDuration: (60*60*9), daysToIterate: 60, probabilitiesForClocksPerWeekday: [0, 1], probabilitiesForClocksPerWeekend: [1])
        }
        else if profileName == "Gym" {
            self.init(minStartOffset: (60*60*15), maxStartOffset: (60*60*19), minClockDuration: (60*45), maxClockDuration: (60*90), daysToIterate: 120, probabilitiesForClocksPerWeekday: [0.4, 0.6], probabilitiesForClocksPerWeekend: [0.2, 0.8])
        }
        else if profileName == "Reading" {
            self.init(minStartOffset: (60*60*12), maxStartOffset: (60*60*21), minClockDuration: (60*20), maxClockDuration: (60*60*2), daysToIterate: 40, probabilitiesForClocksPerWeekday: [0.5, 0.5], probabilitiesForClocksPerWeekend: [0.2, 0.8])
        }
        else if profileName == "Coding" {
            self.init(minStartOffset: (60*60*10), maxStartOffset: (60*60*20), minClockDuration: (60*45), maxClockDuration: (60*60*4), daysToIterate: 120, probabilitiesForClocksPerWeekday: [0.3, 0.7], probabilitiesForClocksPerWeekend: [0, 1])
        }
        else {
            self.init(minStartOffset: 0, maxStartOffset: 0, minClockDuration: 0, maxClockDuration: 0, daysToIterate: 0, probabilitiesForClocksPerWeekday: [], probabilitiesForClocksPerWeekend: [])
        }
    }
}