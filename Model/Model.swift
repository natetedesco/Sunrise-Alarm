//
//  Model.swift
//  Sunrise Alarm
//  Created by Developer on 4/22/24.
//

import Foundation
import CoreLocation

@Observable class Model {
    var alarm: Alarm
    var activeSheet: Sheet?
    var showWakeUp = false
    
    var storage: Storage
    var purchases: Purchases
    var notifications: Notifications
    var locationService: LocationService
    
    init(
        alarm: Alarm = Alarm(),
        storage: Storage = Storage(),
        purchases: Purchases = Purchases(),
        notifications: Notifications = Notifications(),
        locationService: LocationService = LocationService()
    ) {
        self.alarm = alarm
        self.storage = storage
        self.purchases = purchases
        self.notifications = notifications
        self.locationService = locationService
        
        loadAlarm()
        shouldShowWakeView()
        checkAlarm()
    }
    
    // load
    func loadAlarm() {
        self.alarm = storage.load()
    }
    
    // Set Alarm
    func setAlarm() {
        guard let sunrise = locationService.sunrise else { return }
        let alarmTime = getAdjustedTime(for: sunrise, selectedTime: alarm.selectedTime)
        
        alarm.time = alarmTime
        notifications.setAlarm(date: Date().addingTimeInterval(10), sound: alarm.sound)
        
        if alarm.reminder {
            notifications.setReminder(date: alarm.reminderTime)
        }
        
        storage.save(alarm)
    }
    
    // Stop Alarm
    func stopAlarm() {
        notifications.turnOff()
        showWakeUp = false
        
        setAlarm()
    }
    
    // Toggle Alarm
    func toggleAlarm() {
        if alarm.isSet {
            setAlarm()
        } else {
            notifications.turnOff()
            storage.save(alarm)
        }
    }
    
    // Should show wake up?
    func shouldShowWakeView() {
        if alarm.isSet && Date() > alarm.time ?? Date() {
            print("last alarm \(formatTime(alarm.time ?? Date()))")
            showWakeUp = true
        }
    }
    
    // Check initial Alarm
    func checkAlarm() {
        if alarm.isSet {
            Task {
                let scheduledNotifications = await notifications.hasScheduledNotifications()
                let notificationTimes = await notifications.getScheduledNotificationTimes()
                
                if !scheduledNotifications {
                    print("No notifications set")
                } else {
                    for (index, notification) in notificationTimes.enumerated() {
                        if index >= 2 { break }
                        print("Notification set for: \(formatTime(notification))am")
                    }
                }
            }
        } else {
            print("Alarm is not set")
        }
    }
}
