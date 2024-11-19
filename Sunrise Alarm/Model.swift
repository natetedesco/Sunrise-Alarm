//
//  Model.swift
//  Sunrise Alarm
//  Created by Developer on 4/22/24.
//

import Foundation
import CoreLocation
import WeatherKit
import BackgroundTasks



@Observable class AlarmModel: NSObject, CLLocationManagerDelegate {
    var settings = Settings()
    var sunrise: Sunrise?
    
    let locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    
    var showSoundView = false
    var showSettingsView = false
    var showAlarmSet = false
    var showPayWall = false
    
    let alarmKey = "LastSunriseAlarm"
    let settingsKey = "SavedData"
    
    override init() {
        super.init()
        
        if let data = UserDefaults.standard.data(forKey: alarmKey) {
            if let decoded = try? JSONDecoder().decode(Sunrise.self, from: data) {
                self.sunrise = decoded
            }
        }
        
        if let data = UserDefaults.standard.data(forKey: settingsKey) {
            if let decoded = try? JSONDecoder().decode(Settings.self, from: data) {
                self.settings = decoded
            }
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    
    // Save Alarm Settings
    func save() {
        if let encoded = try? JSONEncoder().encode(settings) {
            UserDefaults.standard.set(encoded, forKey: settingsKey)
        }
    }
    
    // Set Alarm
    func setAlarm() {
        NotificationManager.shared.removeAllPendingNotificationRequests()
        BGTaskScheduler.shared.cancelAllTaskRequests()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d:h:mm"
        
        if let sunriseTime = sunrise?.sunriseTime {
            NotificationManager.shared.setAlarm(date: sunriseTime)
            print("Alarm Set for \(sunriseTime)")
        }
        
        if settings.setAlarmReminder {
            NotificationManager.shared.setReminder(
                date: settings.alarmReminderTime,
                repeats: settings.repeating.contains("Everyday"))
            print("Reminder Set for \(settings.alarmReminderTime)")
        }
        
        scheduleBackgroundTask()
    }
    
    // Schedule Background Task
    func scheduleBackgroundTask() {
        
        let request = BGAppRefreshTaskRequest(identifier: "com.sunriseAlarm.backgroundTask")
        let date = Calendar.current.date(byAdding: .second, value: 10, to: Date())!
        
        request.earliestBeginDate = date
        
        do {
            try BGTaskScheduler.shared.submit(request)
            NotificationManager.shared.setAlarm(date: Date())
            print("Background task scheduled for \(date)")
        } catch {
            print("Failed to schedule background task: \(error)")
        }
    }
    
    // Background Task
    func backgroundTask(task: BGAppRefreshTask) {
        print("Task did run")
        
        if let location = sunrise?.location {
            getSunriseTime(for: location) { sunriseTime in
                NotificationManager.shared.setAlarm(date: sunriseTime!)
                print("alarm set for \(String(describing: sunriseTime))")
                task.setTaskCompleted(success: true)
            }
        }
        
        // Schedule Next Task
        scheduleBackgroundTask()
    }
    
    
    func turnOffAlarm() {
        NotificationManager.shared.removeAllPendingNotificationRequests()
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        getCityName(for: location) { [weak self] cityName in
            self?.getSunriseTime(for: location) { sunriseTime in
                self?.createAlarm(location: location, cityName: cityName, sunriseTime: sunriseTime)
            }
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            if manager.authorizationStatus == .authorizedWhenInUse {
                locationManager.requestLocation()
            }
        }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }

    // Save Location & SunriseTime
    func createAlarm(location: CLLocation, cityName: String, sunriseTime: Date?) {
        guard let sunriseTime = sunriseTime else { return }
        DispatchQueue.main.async {
            self.sunrise = Sunrise(location: location, cityName: cityName, sunriseTime: sunriseTime)
            
            if let encodedData = try? JSONEncoder().encode(self.sunrise) {
                UserDefaults.standard.set(encodedData, forKey: self.alarmKey)
            }
        }
    }

    // Get City Name
    func getCityName(for location: CLLocation, completion: @escaping (String) -> Void) {
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first else {
                completion("Unknown City")
                return
            }
            let cityName = placemark.locality ?? "Unknown City"
            completion(cityName)
        }
    }

    // Get Sunrise Time
    func getSunriseTime(for location: CLLocation, completion: @escaping (Date?) -> Void) {
        Task {
            let weatherService = WeatherService()
            do {
                // Access the forecast for tomorrow (index 1)
                let weather = try await weatherService.weather(for: location)
                let tomorrowForecast = weather.dailyForecast[1]
                let sunEvents = tomorrowForecast.sun
                completion(sunEvents.sunrise)
            } catch {
                completion(nil)
            }
        }
    }
}
