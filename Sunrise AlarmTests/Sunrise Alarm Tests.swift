//
//  Sunrise_AlarmTests.swift
//  Sunrise AlarmTests
//  Created by Developer on 12/3/24.
//

import Testing
import Foundation
import CoreLocation

// Wake View tests
extension Sunrise_AlarmTests {
    
    // Alarm time in the future
    @Test func showWakeViewFuture() {
        model.alarm.isSet = true
        model.alarm.time = testSunrise.addingTimeInterval(10)
        
        model.shouldShowWakeView()
        
        #expect(model.showWakeUp == false)
    }
    
    // Alarm time in the past
    @Test func showWakeViewPast() {
        model.alarm.isSet = true
        model.alarm.time = testSunrise.addingTimeInterval(-10)
        
        model.shouldShowWakeView()
        
        #expect(model.showWakeUp == true)
    }
    
    //
    @Test func showWakeViewPastOff() {
        model.alarm.isSet = false
        model.alarm.time = testSunrise.addingTimeInterval(-10)
        
        model.shouldShowWakeView()
        
        #expect(model.showWakeUp == false)
    }
}

// Set Alarm Tests
extension Sunrise_AlarmTests {
    
    @Test func setAlarm() {
        model.alarm.selectedTime = "sunrise"
        locationService.sunrise = testSunrise
        
        // Execute
        model.setAlarm()
        
        // Verify
        #expect(model.alarm.time == testSunrise)
        #expect(notifications.alarmSet == testSunrise)
    }
    
    @Test func setAlarmWithDelay() {
        model.alarm.selectedTime = "30 minutes before sunrise"
        locationService.sunrise = testSunrise
        
        // Execute
        model.setAlarm()
        
        // Verify
        #expect(model.alarm.time == testSunrise.addingTimeInterval(-30 * 60))
        #expect(notifications.alarmSet == testSunrise.addingTimeInterval(-30 * 60))
    }
    
    @Test func stopAlarm() {
        model.showWakeUp = true
        
        locationService.sunrise = testSunrise
        
        model.stopAlarm()
        
        #expect(model.showWakeUp == false)
        #expect(model.alarm.time == testSunrise)
        #expect(notifications.alarmSet == testSunrise)
    }
    
    @Test func testAlarmToggleOff() async {
        model.alarm.isSet = false
        model.toggleAlarm()
        
        #expect(model.alarm.isSet == false)
    }
    
    @Test func testAlarmToggleOn() async {
        model.alarm.isSet = true
        model.toggleAlarm()
        
        #expect(model.alarm.isSet == true)
    }
}


