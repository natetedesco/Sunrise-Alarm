//
//  SettingsView.swift
//  Sunrise Alarm
//  Created by Developer on 4/21/24.
//

import SwiftUI
import AVFoundation

struct AlarmView: View {
    @State var alarm: AlarmModel
    @AppStorage("pro") var proAccess: Bool = true
    @State var showPayWall = false
    
    @Environment(\.dismiss) var dismiss
    
    @State var alarmOptions = ["Sunrise", "5 minutes before", "10 minutes before", "15 minutes before", "20 minutes before", "25 minutes before", "30 minutes before"]
    @State var repeatingOptions = ["Never", "Everyday"]
    @State var alarmSounds = ["Alarm 1", "Alarm 2"]

    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {

                        // General
                        Text("Wake Up")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .padding(.leading)
//                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 16) {
                            
                            // Wake Up at
                            HStack {
//                                Label("Wake up at", systemImage: "alarm.fill")
                                Text("Wake up at")
                                Spacer()
                                Picker("", selection: $alarm.settings.alarmTime) {
                                    ForEach(alarmOptions, id: \.self) { option in
                                        Text(option)
                                    }
                                }
                                .padding(.trailing, -8)
                            }
                            .frame(height: 32)
                            
                            Divider().padding(.horizontal, -16)

                            // Repeats
                            HStack {
//                                Label("Repeats", systemImage: "repeat")
                                Text("Repeats")
                                Spacer()
                                Picker("", selection: $alarm.settings.repeating) {
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
                        Text("Day Before Reminder")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundStyle(.secondary)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Volume Reminder
                        VStack(spacing: 16) {
                            Toggle(isOn: $alarm.settings.setAlarmReminder) { Text("Volume Reminder") }
                                .frame(height: 36)
                            
                            Divider().padding(.horizontal, -16)
                            
                            HStack {
                                Text("Remind me at")
                                Spacer()
                                DatePicker("", selection: $alarm.settings.alarmReminderTime,
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
                        
                        HStack {
                            Text("Sound")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button {
//                                AudioServicesPlaySystemSound(rawValue: "Alarm1.aif")
                            } label: {
                                Text("Test")
                                    .font(.caption)
                            }
                            .padding(.trailing)
                        }
                        .padding(.horizontal)
                        VStack(spacing: 16) {
                            HStack {
                                Text("Alarm Sound")
                                Spacer()
                                Picker("Sounds", selection: $alarm.settings.alarmSound) {
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
                        
                        Spacer()
                    }
                }
                Button {
                    dismiss()
                    alarm.settings.alarmSet = true
                    alarm.save()
                    alarm.setAlarm()
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
            .toggleStyle(SwitchToggleStyle(tint: Color.orange))
            .padding(.horizontal, 20)
            .accentColor(.orange)
            .sheet(isPresented: $showPayWall) {
                PayWall()
                    .presentationDetents([.fraction(4/10)])
                    .presentationCornerRadius(40)
                    .presentationBackground(.regularMaterial)
            }
            .onChange(of: alarm.settings.alarmTime) { showPaywall() }
            .onChange(of: alarm.settings.repeating) { showPaywall() }
            .onChange(of: alarm.settings.snooze) { showPaywall() }
            .onChange(of: alarm.settings.setAlarmReminder) { showPaywall() }
            .onChange(of: alarm.settings.alarmReminderTime) { showPaywall() }
            .onChange(of: alarm.settings.alarmSound) { showPaywall() }
            .onChange(of: alarm.settings.volume) { showPaywall() }
        }
    }
    func showPaywall() {
        if !proAccess {
            showPayWall = true
            alarm.settings = defaultSettings
        }
    }
    var defaultSettings = Settings()
}

#Preview {
    ContentView(alarm: AlarmModel())
        .sheet(isPresented: .constant(true)) {
            AlarmView(alarm: AlarmModel())
                .presentationCornerRadius(40)
                .presentationBackground(.regularMaterial)
        }
}
