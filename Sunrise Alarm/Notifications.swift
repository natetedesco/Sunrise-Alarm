//
//  Notification.swift
//  Sunrise Alarm
//  Created by Developer on 4/23/24.
//

import Foundation
import UserNotifications
import AVFoundation

@Observable class NotificationManager: NSObject, UNUserNotificationCenterDelegate  {
    var notifications: [UNNotificationRequest] = []
    var authorizationStatus: UNAuthorizationStatus?
    
    override init() { super.init() }
    
    func setReminder(date: Date, repeats: Bool, id: String = "reminder") {
        let content = UNMutableNotificationContent()
        content.title = "Alarm set Tomorrow"
        content.body = "Make sure your volume is turned on"
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        let req = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil) // Show in background
        UNUserNotificationCenter.current().delegate = self // Play in foreground
    }
    
    // Set Notification
    func setAlarm(date: Date, id: String = "alarm") {
        
        let content = UNMutableNotificationContent()
        content.title = "Rise and Shine"
        content.body = "Open the app to turn off"
        content.sound = UNNotificationSound.init(named:UNNotificationSoundName(rawValue: "Alarm1.aif"))
        
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let req = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil) // Show in background
        UNUserNotificationCenter.current().delegate = self // Play in foreground
    }
    
    func stopDailyAlarm(id: String = "reminder") {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    // Remove Notifications
    func removeAllPendingNotificationRequests() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // Reload Authorization
    func reloadAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.authorizationStatus = settings.authorizationStatus
            }
        }
    }
    
    // Request Authorization
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { isGranted, _ in
            DispatchQueue.main.async {
                self.authorizationStatus = isGranted ? .authorized: .denied
            }
        }
    }
    
    // Reload Local Notifications
    func reloadLocalNotifications() {
        print("reloadLocalNotifications")
        UNUserNotificationCenter.current().getPendingNotificationRequests { notifications in
            DispatchQueue.main.async {
                self.notifications = notifications
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound])
    }
}
