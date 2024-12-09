//
//  Location.swift
//  Sunrise Alarm
//  Created by Developer on 12/3/24.
//

import Foundation
import CoreLocation
import WeatherKit

@Observable class LocationService: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var onLocationUpdate: ((CLLocation) -> Void)?
    var currentLocation: CLLocation? { didSet { handleLocationUpdate() }}
    
    var sunrise: Date?
    var city: String?
    
    override init() {
        super.init()
        startUpdatingLocation()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.distanceFilter = 1000  // 1km
    }
    
    
    private func handleLocationUpdate() {
        guard let location = currentLocation else { return }
        onLocationUpdate?(location)
    }
    
    func requestLocationPermissionIfNeeded() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        Task { self.city = await getCity(for: location) }
        Task { self.sunrise = await getSunrise(for: location) }
    }
    
    func getSunrise(for location: CLLocation?) async -> Date? {
        let weatherService = WeatherService()
        
        guard let location = location else { return nil }
        
        do {
            let weather = try await weatherService.weather(for: location)
            let todaySunrise = weather.dailyForecast[0].sun.sunrise ?? Date()
            let tomorrowSunrise = weather.dailyForecast[1].sun.sunrise ?? Date()
            
            if Date() < todaySunrise {
                return todaySunrise
            } else {
                print("Tomorrow's sunrise: \(formatTime(tomorrowSunrise))am")
                return tomorrowSunrise
            }
        } catch {
            print("Failed to get sunrise time: \(error)")
            return nil
        }
    }
    
    func getCity(for location: CLLocation) async -> String {
        let placemarks = try? await CLGeocoder().reverseGeocodeLocation(location)
        let city = placemarks?.first?.locality ?? "Failed to get location"
        print(city)
        return city
    }
}
