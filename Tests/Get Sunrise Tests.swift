//
//  Get Sunrise Tests.swift
//  Sunrise AlarmTests
//  Created by Developer on 12/6/24.
//

import Foundation
import Testing
import CoreLocation

struct GetSunriseTests {
    let mockLocation = MockLocationService()
    let calendar = Calendar.current
    let testLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
    
    @Test func getSunrise_at1AM_beforeTodaySunrise_returnsToday() async {
        
        // Set current time to 1 AM
        let components = DateComponents(year: 2024, month: 12, day: 6, hour: 1)
        
        // Set sunrise to 7 AM same day
        let sunriseComponents = DateComponents(year: 2024, month: 12, day: 6, hour: 7)
        mockLocation.sunrise = calendar.date(from: sunriseComponents)!
        
        let result = await mockLocation.getSunrise(for: testLocation)
        
        #expect(mockLocation.sunrise == result)
    }
    
    @Test func getSunrise_at8PM_afterTodaySunrise_returnsTomorrowSunrise() async {
        
        // Set current time to 8 PM
        let time = DateComponents(year: 2024, month: 12, day: 6, hour: 20)
        
        // Set sunrise to 7 AM next day
        let sunrise = DateComponents(year: 2024, month: 12, day: 7, hour: 7)
        mockLocation.sunrise = calendar.date(from: sunrise)!
        
        let result = await mockLocation.getSunrise(for: testLocation)
        
        #expect(mockLocation.sunrise == result)
    }
}
