//
//  Alarm.swift
//  Sunrise Alarm
//  Created by Developer on 4/27/24.
//

import Foundation

struct Alarm: Codable, Equatable {
    var isSet = false
    
    var time: Date?
    var selectedTime = "sunrise"
    
    var snooze = false
    var reminder = false
    var reminderTime = Calendar.current.date(from: DateComponents(hour: 20, minute: 0)) ?? Date()
    
    var sound = "Alarm Clock"
}

var alarmOptions = [
    "30 minutes after",
    "25 minutes after",
    "20 minutes after",
    "15 minutes after",
    "10 minutes after",
    "5 minutes after",
    "sunrise",
    "5 minutes before",
    "10 minutes before",
    "15 minutes before",
    "20 minutes before",
    "25 minutes before",
    "30 minutes before",
]

var alarmSounds = [
    "Alarm Clock",
    "Hawkin Woods",
    "Prelude in C"
]
