//
//  Alarm.swift
//  Sunrise Alarm
//  Created by Developer on 4/27/24.
//

import Foundation

struct Alarm: Codable, Equatable {
    var isSet = false
    
    var sunriseTime: Date?
    var city: String?
    
    var time = "Sunrise"
    var repeating = "Never"
    var snooze = false
    var reminder = false
    var reminderTime = Calendar.current.date(from: DateComponents(hour: 20, minute: 0)) ?? Date()
    
    var sound = "Alarm 1"
    var sounds = ["Alarm 1", "Alarm 2"]
    var volume: Double = 100
}

var alarmOptions = [
    "Sunrise",
    "5 minutes before",
    "10 minutes before",
    "15 minutes before",
    "20 minutes before",
    "25 minutes before",
    "30 minutes before"
]
var repeatingOptions = [
    "Never",
    "Everyday"
]
var alarmSounds = [
    "Alarm 1",
    "Alarm 2"
]
