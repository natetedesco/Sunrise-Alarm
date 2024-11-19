//
//  Sunrise_AlarmApp.swift
//  Sunrise Alarm
//
//  Created by Nate Tedesco on 8/19/23.
//

import SwiftUI
import TipKit
import BackgroundTasks

@main
struct Sunrise_AlarmApp: App {
    @State var model = AlarmModel()
    @StateObject var purchaseManager = PurchaseManager()
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    @AppStorage("showWakeUp") var showWakeUp: Bool = false

    
    init() {
        // Register for background tasks
        //        try? Tips.configure()
        registerBackgroundTask()
    }

    func registerBackgroundTask() {
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.sunriseAlarm.backgroundTask", using: nil) { task in
            model.backgroundTask(task: task as! BGAppRefreshTask)
        }
        print("task registered")
    }
    
    
    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                Onboarding()
            } else {
                ContentView(alarm: model)
                    .task {
                        await purchaseManager.updatePurchasedProducts()
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
