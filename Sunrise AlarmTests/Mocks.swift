//
//  Mocks.swift
//  Sunrise AlarmTests
//  Created by Developer on 12/6/24.
//

import Foundation
import CoreLocation

struct Sunrise_AlarmTests {
    let model: Model
    let storage = MockStorage()
    let notifications = MockNotifications()
    let locationService = MockLocationService()
    let testSunrise = Date()
    
    init() {
        model = Model(
            storage: storage,
            notifications: notifications,
            locationService: locationService
        )
    }
}

// Location
class MockLocationService: LocationService {
    var currentDate: Date = Date()
    
    override func getSunrise(for location: CLLocation?) async -> Date? {
        return sunrise
    }
    
    override func getCity(for location: CLLocation) async -> String {
        return city ?? "Test City"
    }
}

// Storage
class MockStorage: Storage {
    private var savedAlarm: Alarm?
    
    override func save(_ alarm: Alarm) {
        savedAlarm = alarm
    }
    
    override func load() -> Alarm {
        return Alarm()
    }
}

// Notifications
class MockNotifications: Notifications {
    var alarmSet: Date?
    var reminderSet: Date?

    override func setAlarm(date: Date, id: String = "alarm") {
        alarmSet = date
    }
    
    override func setReminder(date: Date, id: String = "reminder") {
        reminderSet = date
    }
    
    override func turnOff() {
        alarmSet = nil
        reminderSet = nil
    }
}

