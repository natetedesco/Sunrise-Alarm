//
//  ContentView.swift
//  Sunrise Alarm
//  Created by Nate Tedesco on 8/19/23.
//

import SwiftUI
import TipKit

struct ContentView: View {
    @Environment(Model.self) var model
    var tip = CheckAlarmTip()
    
    var body: some View {
        @Bindable var model = model

        ZStack {
            
            // City
            HStack {
                Image(systemName: "location.fill")
                Text(model.locationService.locationManager.authorizationStatus == .denied ? "Location Services Denied" : model.locationService.city ?? "Loading Location")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            .fontDesign(.rounded)
            .padding(.top)
            .frame(maxHeight: .infinity, alignment: .top)
            
            HStack {
                // Settings
                Button { lightHaptic()
                    model.activeSheet = .settings
                } label: {
                    MainButton(
                        image: "sun.max.fill",
                        padding: 10,
                        font: .title2
                    )
                }
                
                Spacer()
                
                // Alarm
                Button { lightHaptic()
                    model.activeSheet = .alarm
                    CheckAlarmTip().invalidate(reason: .actionPerformed)
                } label: {
                    AlarmButton(
                        image: "alarm.fill",
                        padding: 13,
                        font: .title3
                    )
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.horizontal, 32)
            
            VStack(spacing: 0) {
                // Sunrise Tomorrow
                HStack {
                    Image(systemName: "sunrise.fill")
                        .font(.callout)
                    Text("Sunrise Tomorow")
                }
                
                // Sunrise Time
                HStack {
                    Text("\(model.locationService.sunrise != nil ? formatTime(model.locationService.sunrise!) : "0:00")")
                        .font(.system(size: 116))
                        .fontWeight(.medium)
                    
                    Text("AM")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                        .padding(.trailing, -16)
                }
                .fontDesign(.rounded)
                .animation(.default, value: model.locationService.city)
                .onLongPressGesture {
                    #if DEBUG
                    model.showWakeUp.toggle()
                    #endif
                }
                
                // Alarm Toggle
                Toggle("", isOn: $model.alarm.isSet)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                    .scaleEffect(1.4)
                    .frame(width: 50)
                    .padding(.trailing)
                    .onChange(of: model.alarm.isSet) {
                        model.toggleAlarm()
                    }
            }
            .padding(.bottom, -16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RadialGradient(gradient: Gradient(colors: model.alarm.isSet ? [
                Color(red: 1.0, green: 0.7, blue: 0.5),
                Color(red: 1.0, green: 0.85, blue: 0.7),
                Color(red: 0.9, green: 0.6, blue: 0.75),
                Color(red: 0.5, green: 0.6, blue: 0.8),
                Color(red: 0.2, green: 0.3, blue: 0.4),
                Color(red: 0.1, green: 0.1, blue: 0.125)
            ] : [
                Color(red: 0.05, green: 0.05, blue: 0.05),
                Color(red: 0.05, green: 0.05, blue: 0.05),
            ]),
                           center: .bottom,
                           startRadius: 0,
                           endRadius: 400)
            .animation(.default, value: model.alarm.isSet)
            .blur(radius: 50)
            .scaleEffect(1.1)
            .ignoresSafeArea()
        )
        .onLongPressGesture(perform: {
            #if DEBUG
            model.purchases.showOnboarding = true
            #endif
        })
        
        .sheet(item: $model.activeSheet) { sheet in
            switch sheet {
            case .alarm:
                AlarmView(alarm: model.alarm)
                    .thinSheetBackground()
            case .settings:
                SettingsView()
                    .thinSheetBackground()
            case .alarmSet:
                AlarmSet()
                    .presentationDetents([.fraction(4/10)])
                    .thinSheetBackground()
            }
        }
        .sheet(isPresented: $model.purchases.showPaywall) {
            Paywall()
                .smallSheetBackground()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MainButton: View {
    var image: String
    var padding: CGFloat
    var font: Font
    var showTip: Bool = false
    
    var body: some View {
        Image(systemName: image)
            .font(font)
            .foregroundColor(.orange)
            .fontWeight(.semibold)
            .padding(padding)
            .background(Circle().foregroundStyle(.thinMaterial))
            .padding(.top)
    }
}

struct AlarmButton: View {
    var tip = CheckAlarmTip()
    var image: String
    var padding: CGFloat
    var font: Font
    var showTip: Bool = false
    
    var body: some View {
        Image(systemName: image)
            .font(font)
            .foregroundColor(.orange)
            .fontWeight(.semibold)
            .padding(padding)
            .background(Circle().foregroundStyle(.thinMaterial))
            .padding(.top)
        #if !DEBUG // causes crashing something main thread issue idk
            .popoverTip(tip, arrowEdge: .bottom)
        #endif
    }
}

struct CheckAlarmTip: Tip {
    var title: Text {
        Text("Check your Alarm")
    }
    var message: Text? {
        Text("Make sure everything looks good for your alarm tomorrow.")
        
    }
}

