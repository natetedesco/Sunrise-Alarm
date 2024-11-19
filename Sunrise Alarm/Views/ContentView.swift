//
//  ContentView.swift
//  Sunrise Alarm
//  Created by Nate Tedesco on 8/19/23.
//

import SwiftUI
import TipKit

struct ContentView: View {
    @State var alarm: AlarmModel
    
    @AppStorage("pro") var proAccess: Bool = false
    @AppStorage("showOnboarding") var showOnboarding: Bool = false
    @AppStorage("showWakeUp") var showWakeUp: Bool = false
    
    var checkAlarm = checkAlarmTip()
    
    var body: some View {
        ZStack {
            
            // City Name
            HStack {
                Image(systemName: "location.fill")
                Text(alarm.sunrise?.cityName ?? "Loading Location")
                    .onTapGesture {
                        showOnboarding = true
                    }
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            .padding(.top, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onTapGesture {
                showOnboarding = true
            }
            
            // Settings View
            HStack {
                Button {
                    alarm.showSoundView.toggle()
                } label: {
                    Image(systemName: "sun.max.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                        .fontWeight(.semibold)
                        .padding(10)
                        .background(Circle().foregroundStyle(.thinMaterial))
                        .padding(.top)
                }
                
                Spacer()
                
                // Alarm View
                Button {
                    alarm.showSettingsView.toggle()
                    checkAlarm.invalidate(reason: .actionPerformed)
                } label: {
                    Image(systemName: "alarm.fill")
                        .font(.title3)
                        .foregroundColor(.orange)
                        .fontWeight(.semibold)
                        .padding(13)
                        .background(Circle().foregroundStyle(.thinMaterial))
                        .padding(.top)
                        .popoverTip(checkAlarm, arrowEdge: .bottom)
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .padding(.horizontal, 32)
            
            // Sunrise Time
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "sunrise.fill")
                        .offset(y: -2)
                        .font(.callout)
                    Text(alarm.sunrise?.sunriseTime == nil ? "Loading Location" : "Sunrise Tomorow")
                }
                
                HStack {
                    Text("\(formattedSunriseTime)")
                        .font(.system(size: 116))
                        .fontWeight(.medium)
                        .onTapGesture {
                            showWakeUp = true
                        }
                    
                    Text("AM")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                        .padding(.trailing, -16)
                }
                .fontDesign(.rounded)
                .animation(.default, value: alarm.sunrise?.cityName)
                
                // Alarm Set
                Toggle("", isOn: $alarm.settings.alarmSet)
                    .controlSize(.large)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                    .scaleEffect(1.4)
                    .frame(width: 50)
                    .padding(.trailing)
                    .padding(.top, -64)
                    .onChange(of: alarm.settings.alarmSet) {
                        alarm.save()
                    }
                
                Spacer()
                
            }
            .padding(.bottom, -16)
        }
        .task {
            if alarm.locationManager.authorizationStatus == .notDetermined {
                alarm.locationManager.requestWhenInUseAuthorization()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RadialGradient(gradient: Gradient(colors: [
                Color(red: 1.0, green: 0.7, blue: 0.5),
                Color(red: 1.0, green: 0.85, blue: 0.7),
                Color(red: 0.9, green: 0.6, blue: 0.75),
                Color(red: 0.5, green: 0.6, blue: 0.8),
                Color(red: 0.2, green: 0.3, blue: 0.4),
                Color(red: 0.1, green: 0.1, blue: 0.125),]),
                           center: .bottom,
                           startRadius: 0,
                           endRadius: 400)
            .cornerRadius(56)
            .blur(radius: 50)
            .scaleEffect(1.1)
            .ignoresSafeArea()
        )
        .sheet(isPresented: $alarm.showSoundView) {
            SunriseAlarmView()
                .pickerStyle(WheelPickerStyle())
                .presentationCornerRadius(40)
                .presentationBackground(.thinMaterial)
        }
        .sheet(isPresented: $alarm.showSettingsView) {
            AlarmView(alarm: alarm)
                .presentationCornerRadius(40)
                .presentationBackground(.thinMaterial)
        }
        
        .sheet(isPresented: $alarm.showAlarmSet) {
            AlarmSet()
                .presentationDetents([.fraction(3/10)])
                .presentationCornerRadius(40)
                .presentationBackground(.regularMaterial)
        }
        .sheet(isPresented: $alarm.showPayWall) {
            PayWall()
                .presentationDetents([.fraction(3/10)])
                .presentationCornerRadius(40)
                .presentationBackground(.regularMaterial)
        }
        .fullScreenCover(isPresented: $showWakeUp) {
            WakeUpView()
                .presentationBackground(.regularMaterial)
        }
    }
    
    var formattedSunriseTime: String {
        guard let alarm = alarm.sunrise else {
            return "0:00"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm"
        return dateFormatter.string(from: alarm.sunriseTime)
    }
}

struct AlarmSet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("You're Alarm is Set!")
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
            Text("Make sure your volume is on. See you tomorrow!")
                .multilineTextAlignment(.center)
                .padding(.top, -16)
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("Dismiss")
                    .foregroundStyle(.white)
                    .fontWeight(.medium)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 24).foregroundStyle(LinearGradient(colors: [.orange.opacity(0.9), .orange, .yellow.opacity(0.9)], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .cornerRadius(24)
            }
        }
        .padding(.horizontal, 32)
        .padding(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(alarm: AlarmModel())
    }
}

struct checkAlarmTip: Tip {
    var title: Text {
        Text("Check your Alarm")
    }
    var message: Text? {
        Text("Make sure everything looks good for your alarm tomorrow.")
        
    }
}

//struct setAlarmTip: Tip {
//    var title: Text {
//        Text("Turn On Alarm")
//    }
//    var message: Text? {
//        Text("Switch the toggle on to set your alarm")
//    }
//}
