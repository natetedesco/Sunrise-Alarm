//
//  Notification.swift
//  Sunrise Alarm
//  Created by Developer on 4/23/24.
//

import Foundation
import UserNotifications
import AVFoundation

@Observable class Notifications: NSObject, UNUserNotificationCenterDelegate  {
    var notifications: [UNNotificationRequest] = []
    var authorizationStatus: UNAuthorizationStatus?
    
    func setAlarm(date: Date, id: String = "alarm") {
        for i in 0..<50 {
            let content = UNMutableNotificationContent()
            content.title = "Rise and Shine"
            content.body = "Open the app to turn off and set tomorrows alarm"
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "Alarm_short.aif"))
            
            let triggerDate = date.addingTimeInterval(Double(i * 5))
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let req = UNNotificationRequest(identifier: "\(id)_\(i)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(req) { error in
                if let error = error {
                    print("Error scheduling notification \(i): \(error)")
                }
            }
        }
        print("\nAlarm set for: \(formatTime(date))am")
        UNUserNotificationCenter.current().delegate = self
    }
    
    func setReminder(date: Date, id: String = "reminder") {
        let content = UNMutableNotificationContent()
        content.title = "Alarm set Tomorrow"
        content.body = "Make sure your volume is turned on"
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let req = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil) // Show in background
        UNUserNotificationCenter.current().delegate = self // Play in foreground
    }
    
//    func stopDailyAlarm(id: String = "reminder") {
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
//    }
    
    func turnOff() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("\nAlarm Off")
    }
    
    func hasScheduledNotifications() async -> Bool {
        let pendingNotifications = await UNUserNotificationCenter.current().pendingNotificationRequests()
        return !pendingNotifications.isEmpty
    }
    
    func getScheduledNotificationTimes() async -> [Date] {
        let notifications = await UNUserNotificationCenter.current().pendingNotificationRequests()
        return notifications.compactMap { request in
            if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                return trigger.nextTriggerDate()
            }
            return nil
        }.sorted()
    }
    
    func reloadAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { isGranted, _ in
            DispatchQueue.main.async {
                self.authorizationStatus = isGranted ? .authorized: .denied
            }
        }
    }
    
//    func reloadLocalNotifications() {
//        print("reloadLocalNotifications")
//        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
//            DispatchQueue.main.async {
//                self.notifications = notifications
//            }
//        }
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.sound])
//    }
}
