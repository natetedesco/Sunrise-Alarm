//
//  Helpers.swift
//  Sunrise Alarm
//  Created by Developer on 12/5/24.
//

import Foundation
import SwiftUI

enum Sheet: Identifiable {
    case alarm
    case settings
    case alarmSet
    
    var id: Self { self }
}

func formatTime(_ time: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm"
    return formatter.string(from: time)
}

func getAdjustedTime(for sunrise: Date, selectedTime: String) -> Date {
    if selectedTime == "sunrise" { return sunrise }
    
    let regex = /(\d+) minutes (before|after)/
    guard let match = selectedTime.firstMatch(of: regex),
          let minutes = Int(match.1) else { return sunrise }
          
    let adjustment = match.2 == "after" ? minutes : -minutes
    return Calendar.current.date(byAdding: .minute, value: adjustment, to: sunrise) ?? sunrise
}

func lightHaptic() {
    let impactLit = UIImpactFeedbackGenerator(style: .light)
    impactLit.impactOccurred()
}

func softHaptic() {
    let impactLit = UIImpactFeedbackGenerator(style: .soft)
    impactLit.impactOccurred()
}

