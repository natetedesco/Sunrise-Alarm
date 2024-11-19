//  Model.swift
//  Sunrise Alarm
//  Created by Developer on 4/22/24.
//

import Foundation
import BackgroundTasks

@Observable class Model {
    var alarm = Alarm()
    
    var showAlarmSet = false
    var showSettingsView = false
    var showWakeUp = false
    var showSoundView = false
    var showPaywall = false
    
    let storage = Storage.shared
    let notifications = NotificationManager()
    let locationManager = LocationManager()
    
    init() {
        print("Initializing Model")
        self.alarm = storage.loadAlarm()
        print("Loaded alarm: \(self.alarm)")
    }
    
    func updateSunriseInfo() async {
        print("Updating sunrise info")
        if let location = locationManager.getCurrentLocation() {
            print("Got current location: \(location)")
            if let sunriseTime = await locationManager.getSunriseTime(for: location) {
                print("Got sunrise time: \(sunriseTime)")
                let city = await locationManager.getCityName(for: location)
                print("Got city name: \(city)")
                alarm.sunriseTime = sunriseTime
                alarm.city = city
                storage.saveAlarm(alarm)
                print("Saved updated alarm: \(alarm)")
            }
        } else {
            print("Failed to get current location")
        }
    }
    
    func setAlarm() {
        print("Setting alarm")
        alarm.isSet = true
        storage.saveAlarm(alarm)
        print("Alarm is set: \(alarm.isSet)")
        
        if let sunriseTime = alarm.sunriseTime {
            notifications.setAlarm(date: sunriseTime)
            print("Alarm set for \(sunriseTime)")
        }
        
        if alarm.reminder {
            notifications.setReminder(
                date: alarm.reminderTime,
                repeats: alarm.repeating.contains("Everyday"))
            print("Reminder set for \(alarm.reminderTime), repeats: \(alarm.repeating.contains("Everyday"))")
        }
    }
    
    func turnOffAlarm() {
        print("Turning off alarm")
        alarm.isSet = false
        storage.saveAlarm(alarm)
        print("Alarm is set: \(alarm.isSet)")
        notifications.removeAllPendingNotificationRequests()
        BGTaskScheduler.shared.cancelAllTaskRequests()
        print("Canceled all notifications and background tasks")
    }
}

import CoreLocation
import WeatherKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var currentLocation: CLLocation?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        print("LocationManager initialized and requested authorization")
    }
    
    func getCurrentLocation() -> CLLocation? {
        print("Current location: \(String(describing: currentLocation))")
        return currentLocation
    }
    
    func getSunriseTime(for location: CLLocation) async -> Date? {
        print("Getting sunrise time for location: \(location)")
        let weatherService = WeatherService()
        do {
            let weather = try await weatherService.weather(for: location)
            let now = Date()
            let todaySunrise = weather.dailyForecast[0].sun.sunrise
            
            if now < todaySunrise ?? Date() {
                return todaySunrise
            }
            
            return weather.dailyForecast[1].sun.sunrise
        } catch {
            print("Failed to get sunrise time: \(error)")
            return nil
        }
    }
    
    func getCityName(for location: CLLocation) async -> String {
        print("Getting city name for location: \(location)")
        return await withCheckedContinuation { continuation in
            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Failed to get city name: \(error)")
                    continuation.resume(returning: "Unknown City")
                } else {
                    let city = placemarks?.first?.locality ?? "Unknown City"
                    print("City name: \(city)")
                    continuation.resume(returning: city)
                }
            }
        }
    }
    
    // MARK: - CLLocationManagerDelegate
    func requestLocation() {
        print("Requesting location")
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        print("Updated current location: \(String(describing: currentLocation))")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}

