//
//  Sunrise_AlarmApp.swift
//  Sunrise Alarm
//  Created by Nate Tedesco on 8/19/23.
//

import SwiftUI
import TipKit
import BackgroundTasks

@main
struct Sunrise_AlarmApp: App {
    @State var model = Model()
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    @AppStorage("showWakeUp") var showWakeUp: Bool = false
    @Environment(\.dismiss) var dismiss


    init() {
        try? Tips.configure()
//        registerBackgroundTask()
    }

//    func registerBackgroundTask() {
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.sunriseAlarm.backgroundTask", using: nil) { task in
//            model.alarm?.handleBackgroundTask(task as! BGAppRefreshTask)
//        }
//        print("task registered")
//    }
    
    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                Onboarding()
            } else {
                ContentView(model: model)
                    .task {
                        await PurchaseManager.shared.updatePurchasedProducts()
                        //                    if model.settings.shouldResetTips {
                        //                        try? Tips.resetDatastore()
                        //                    }
                        try? Tips.configure([
                            .displayFrequency(.immediate),
                            .datastoreLocation(.applicationDefault)
                        ])
                    }
            }
        }
    }
}
