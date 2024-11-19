//
//  Storage.swift
//  Sunrise Alarm
//  Created by Developer on 11/18/24.
//

import Foundation

class Storage {
    static let shared = Storage()
    private init() {}
    
    func saveAlarm(_ alarm: Alarm) {
        if let encoded = try? JSONEncoder().encode(alarm) {
            UserDefaults.standard.set(encoded, forKey: "Alarm")
        }
    }
    
    func loadAlarm() -> Alarm {
        guard let data = UserDefaults.standard.data(forKey: "Alarm"),
              let alarm = try? JSONDecoder().decode(Alarm.self, from: data) else {
            return Alarm()
        }
        return alarm
    }
}
