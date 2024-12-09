//
//  SettingsView.swift
//  Sunrise Alarm
//  Created by Developer on 4/21/24.
//

import SwiftUI
import AVFoundation

struct AlarmView: View {
    @Environment(Model.self) var model
    @State var alarm: Alarm
    
    var body: some View {
        @Bindable var model = model
        
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        
                        // General
                        Headline(text: "Alarm")
                        Card {
                            // Wake Up at
                            HStack {
                                Text("Wake up at")
                                Spacer()
                                Picker("", selection: $alarm.selectedTime) {
                                    ForEach(alarmOptions, id: \.self) { option in
                                        Text(option)
                                    }
                                }
                            }
                            .frame(height: 36)
                            
                            Divider().padding(.horizontal, -16)

                            // Snooze
                            Toggle(isOn: $alarm.snooze) { Text("Snooze") }
                                .toggleStyle(SwitchToggleStyle(tint: Color.orange))
                                .frame(height: 36)
                            
                        }
                        Text("Sunrise time is based on the location you set your alarm.")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .padding(.bottom, 44)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        // Sound
                        HStack {
                            Headline(text: "Sound")
                            Spacer()
                            Button {
                                if let soundURL = Bundle.main.url(forResource: "Alarm_short", withExtension: "aif") {
                                    var soundID: SystemSoundID = 0
                                    AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)
                                    AudioServicesPlaySystemSound(soundID)
                                }
                            } label: {
                                Text("Test")
                                    .font(.caption)
                            }
                            .padding(.trailing)
                        }
                        
                        Card {
                            HStack {
                                Text("Alarm Sound")
                                Spacer()
                                Picker("Sounds", selection: $alarm.sound) {
                                    ForEach(alarmSounds, id: \.self) { option in
                                        Text(option)
                                    }
                                }
                                .padding(.trailing, -8)
                            }
                            .frame(height: 36)
                        }
                        .padding(.bottom, 44)

                        
                        // Reminder
                        Headline(text: "Reminder")
                        Card {
                            
                            // Volume Reminder
                            Toggle(isOn: $alarm.reminder) { Text("Volume Reminder") }
                                .toggleStyle(SwitchToggleStyle(tint: Color.orange))
                                .frame(height: 36)
                            
                            Divider().padding(.horizontal, -16)
                            HStack {
                                Text("Remind me at")
                                Spacer()
                                DatePicker("", selection: $alarm.reminderTime,
                                           displayedComponents: .hourAndMinute
                                )
                            }
                            .frame(height: 36)
                        }
                        Text("Get notified at night to turn your volume on.")
                            .font(.caption)
                            .foregroundStyle(.tertiary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.horizontal, 8)
                    }
                }
                
                Button { lightHaptic()
                    model.alarm = alarm // update alarm
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        model.alarm.isSet = true // sets the toggle and calls toggl()
                    }
                    
                    model.setAlarm()
                
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
            .onChange(of: alarm) {
                if !model.purchases.proAccess {
                    model.purchases.showPaywall = true
                    alarm = model.alarm // reset alarm
                }
            }
            .sheet(isPresented: $model.purchases.showPaywall) {
                Paywall()
                    .presentationDetents([.fraction(4/10)])
                    .presentationCornerRadius(40)
                    .presentationBackground(.regularMaterial)
            }
        }
    }
    @Environment(\.dismiss) var dismiss
}

struct Headline: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.callout)
            .fontWeight(.semibold)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading)
    }
}

extension View {
    func customBackground() -> some View {
        self
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.black.opacity(0.3))
            .cornerRadius(20)
    }
}

struct Card<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            content
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.black.opacity(0.3))
        .cornerRadius(20)
    }
}

#Preview {
    ContentView()
        .sheet(isPresented: .constant(true)) {
            AlarmView(alarm: Alarm())
                .presentationCornerRadius(40)
                .presentationBackground(.regularMaterial)
        }
}

