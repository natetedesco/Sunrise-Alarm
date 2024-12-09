//
//  Storage.swift
//  Sunrise Alarm
//  Created by Developer on 11/18/24.
//

import Foundation

class Storage {
    
    func save(_ alarm: Alarm) {
        if let encoded = try? JSONEncoder().encode(alarm) {
            UserDefaults.standard.set(encoded, forKey: "Alarm")
        }
    }
    
    func load() -> Alarm {
        guard let data = UserDefaults.standard.data(forKey: "Alarm"),
              let alarm = try? JSONDecoder().decode(Alarm.self, from: data) else {
            print("New Alarm Create")
            return Alarm()
        }
        return alarm
    }
}
