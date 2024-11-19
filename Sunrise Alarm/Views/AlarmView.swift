//
//  SettingsView.swift
//  Sunrise Alarm
//  Created by Developer on 4/21/24.
//

import SwiftUI
import AVFoundation

struct AlarmView: View {
    @State var model: Model
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        // General
                        Headline(text: "Alarm Time")
                        VStack(spacing: 16) {
                            // Wake Up at
                            HStack {
                                Text("Wake up at")
                                Spacer()
                                Picker("", selection: $model.alarm.time) {
                                    ForEach(alarmOptions, id: \.self) { option in
                                        Text(option)
                                    }
                                }
                            }
                            .frame(height: 36)
                            
                            Divider().padding(.horizontal, -16)
                            
                            // Repeats
                            HStack {
                                Text("Repeats")
                                Spacer()
                                Picker("", selection: $model.alarm.repeating) {
                                    ForEach(repeatingOptions, id: \.self) { option in
                                        Text(option)
                                    }
                                }
                            }
                            .frame(height: 36)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.black.opacity(0.3))
                        .cornerRadius(20)
                        
                        Text("Sunrise will be based on the location you set your alarm.")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .padding(.horizontal)
                            .padding(.bottom, 44)
                            .multilineTextAlignment(.leading)
                        
                        // Reminder
                        Headline(text: "Day Before Reminder")
                        VStack(spacing: 16) {
                            
                            // Volume Reminder
                            Toggle(isOn: $model.alarm.reminder) { Text("Volume Reminder") }
                                .toggleStyle(SwitchToggleStyle(tint: Color.orange))
                                .frame(height: 36)
                            
                            Divider().padding(.horizontal, -16)
                            
                            HStack {
                                Text("Remind me at")
                                Spacer()
                                DatePicker("", selection: $model.alarm.reminderTime,
                                           displayedComponents: .hourAndMinute
                                )
                            }
                            .frame(height: 36)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.black.opacity(0.3))
                        .cornerRadius(20)
                        
                        Text("You will not hear your alarm if your volume is off.")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .padding(.leading).padding(.trailing)
                            .padding(.bottom, 44)
                            .multilineTextAlignment(.leading)
                        
                        // Sound
                        HStack {
                            Headline(text: "Sound")
                            Spacer()
                            Button {
//                                AudioServicesPlaySystemSound(rawValue: "Alarm1.aif")
                            } label: {
                                Text("Test")
                                    .font(.caption)
                            }
                            .padding(.trailing)
                        }
                        
                        VStack(spacing: 16) {
                            HStack {
                                Text("Alarm Sound")
                                Spacer()
                                Picker("Sounds", selection: $model.alarm.sound) {
                                    ForEach(alarmSounds, id: \.self) { option in
                                        Text(option)
                                    }
                                }
                                .padding(.trailing, -8)
                            }
                            .frame(height: 36)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.black.opacity(0.3))
                        .cornerRadius(20)
                    }
                }
                Button {
                    dismiss()
                    model.alarm.isSet = true
                    model.storage.saveAlarm(model.alarm)
                    model.setAlarm()
                    UNUserNotificationCenter.current().requestAuthorization(options:[.badge,.sound,.alert]) { (_, _) in }
                } label: {
                    Text("Set Alarm")
                        .foregroundStyle(.white)
                        .fontWeight(.medium)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 20).foregroundStyle(LinearGradient(colors: [.orange, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)))
                }
            }
            .navigationTitle("Alarm")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal, 20)
            .onChange(of: model.alarm.time) { model.showPaywall.toggle() }
            .onChange(of: model.alarm.repeating) { model.showPaywall.toggle() }
            .onChange(of: model.alarm.snooze) { model.showPaywall.toggle() }
            .onChange(of: model.alarm.reminder) { model.showPaywall.toggle() }
            .onChange(of: model.alarm.reminderTime) { model.showPaywall.toggle() }
            .onChange(of: model.alarm.sound) { model.showPaywall.toggle() }
            .onChange(of: model.alarm.volume) { model.showPaywall.toggle() }
            .sheet(isPresented: $model.showPaywall) {
                Paywall()
                    .presentationDetents([.fraction(4/10)])
                    .presentationCornerRadius(40)
                    .presentationBackground(.regularMaterial)
            }
        }
    }
    
    func showPaywall() {
        if !PurchaseManager.shared.proAccess {
            model.showPaywall = true
            //            model.settings = defaultSettings
        }
    }
    //    var defaultSettings = Settings()
    
    @Environment(\.dismiss) var dismiss
}

struct Headline: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.callout)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .padding(.leading)
    }
}

#Preview {
    ContentView(model: Model())
        .sheet(isPresented: .constant(true)) {
            AlarmView(model: Model())
                .presentationCornerRadius(40)
                .presentationBackground(.regularMaterial)
        }
}


