//
//  ContentView.swift
//  Sunrise Alarm
//  Created by Nate Tedesco on 8/19/23.
//

import SwiftUI
import TipKit

struct ContentView: View {
    @State var model: Model
    var checkAlarm = checkAlarmTip()
    
    var body: some View {
        ZStack {
            
            // City
            HStack {
                Image(systemName: "location.fill")
                Text(model.alarm.city ?? "Loading Location")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            .padding(.top)
            .frame(maxHeight: .infinity, alignment: .top)
            
            HStack {
                // Settings
                Button {
                    model.showSoundView.toggle()
                } label: {
                    MainButton(
                        image: "sun.max.fill",
                        padding: 10,
                        font: .title2
                    )
                }
                
                Spacer()
                
                // Alarm
                Button {
                    model.showSettingsView.toggle()
//                    checkAlarm.invalidate(reason: .actionPerformed)
                } label: {
                    MainButton(
                        image: "alarm.fill",
                        padding: 13,
                        font: .title3
                    )
                        .popoverTip(checkAlarm, arrowEdge: .bottom)
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
                    Text("\(formattedSunriseTime)")
                        .font(.system(size: 116))
                        .fontWeight(.medium)
                    
                    Text("AM")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                        .padding(.trailing, -16)
                }
                .fontDesign(.rounded)
                .animation(.default, value: model.alarm.city)
                
                // Alarm Toggle
                Toggle("", isOn: $model.alarm.isSet)
                    .toggleStyle(SwitchToggleStyle(tint: .orange))
                    .scaleEffect(1.4)
                    .frame(width: 50)
                    .padding(.trailing)
                    .onChange(of: model.alarm.isSet) {
                        model.storage.saveAlarm(model.alarm) // FIX
                    }
            }
            .padding(.bottom, -16)
        }
        .onAppear {
            Task {
                await model.updateSunriseInfo()
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
            .blur(radius: 50)
            .scaleEffect(1.1)
            .ignoresSafeArea()
        )
        .sheet(isPresented: $model.showSoundView) {
            SunriseAlarmView(model: model)
                .pickerStyle(WheelPickerStyle())
                .presentationCornerRadius(40)
                .presentationBackground(.thinMaterial)
                .accentColor(.orange)
        }
        .sheet(isPresented: $model.showSettingsView) {
            AlarmView(model: model)
                .presentationCornerRadius(40)
                .presentationBackground(.thinMaterial)
                .accentColor(.orange)
        }
        
        .sheet(isPresented: $model.showAlarmSet) {
            AlarmSet()
                .presentationDetents([.fraction(3/10)])
                .presentationCornerRadius(40)
                .presentationBackground(.regularMaterial)
        }
        .sheet(isPresented: $model.showPaywall) {
            Paywall()
                .presentationDetents([.fraction(3/10)])
                .presentationCornerRadius(40)
                .presentationBackground(.regularMaterial)
        }
        .fullScreenCover(isPresented: $model.showWakeUp) {
            WakeUpView(model: model)
                .presentationBackground(.regularMaterial)
        }
    }
    
    var formattedSunriseTime: String {
        guard let alarm = model.alarm.sunriseTime else {
            return "0:00"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm"
        return dateFormatter.string(from: alarm)
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
        ContentView(model: Model())
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

struct MainButton: View {
    var image: String
    var padding: CGFloat
    var font: Font
    
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

//struct setAlarmTip: Tip {
//    var title: Text {
//        Text("Turn On Alarm")
//    }
//    var message: Text? {
//        Text("Switch the toggle on to set your alarm")
//    }
//}
