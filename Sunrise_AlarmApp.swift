//
//  Sunrise_AlarmApp.swift
//  Sunrise Alarm
//  Created by Nate Tedesco on 8/19/23.
//

import SwiftUI
import TipKit
import BackgroundTasks

@main struct Sunrise_AlarmApp: App {
    @State var model = Model()
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                Onboarding()
            } else {
                ZStack {
                    ContentView()
                        .environment(model)
                        .onAppear { // App Launch
                            model.shouldShowWakeView()  // Check on initial load
                        }
                        .onChange(of: scenePhase) { oldPhase, newPhase in // bringing to foreground
                            if newPhase == .active {
                                model.shouldShowWakeView()
                            }
                        }
                        .task {
                            try? Tips.configure()
                            await model.purchases.updatePurchasedProducts()
                        }
                    if model.showWakeUp {
                        WakeUpView()
                            .background(.regularMaterial)
                    }
                }
            }
        }
    }
}
