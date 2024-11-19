//
//  Alarm.swift
//  Sunrise Alarm
//  Created by Developer on 4/27/24.
//

import Foundation
import CoreLocation


struct Sunrise: Codable {
    var cityName: String
    var sunriseTime: Date
    
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    
    init(location: CLLocation, cityName: String, sunriseTime: Date) {
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        self.cityName = cityName
        self.sunriseTime = sunriseTime
    }
    
    var location: CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}

struct Settings: Codable, Equatable {
    var alarmSet = false
    var alarmTime = "Sunrise"
    var repeating = "Never"
    var snooze = false
    
    var setAlarmReminder = false
    var alarmReminderTime = Calendar.current.date(from: DateComponents(hour: 20, minute: 0)) ?? Date()

    var alarmSound = "Alarm 1"
    var alarmSounds = ["Alarm 1", "Alarm 2"]
    var volume: Double = 100
}

extension AlarmModel {
    

}
