//
//  Onboarding.swift
//  Sunrise Alarm
//  Created by Developer on 4/21/24.
//

import SwiftUI

struct Onboarding: View {
    @AppStorage("showOnboarding") var showOnboarding: Bool = true
    @State var page = 0
    
    var body: some View {
        ZStack {
            
            TabView(selection: $page) {
                
                VStack {
                    Text("Rise with the Sun")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 4)
                    Text("Waking with the sun can revolutionize your sleep, mood, and overall well-being.")
                        .font(.callout)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 40)
                .tag(0)
                
                VStack(alignment: .leading) {
                    HStack{
                        Text("Feel")
                            .foregroundStyle(LinearGradient(colors: [.yellow, .orange], startPoint: .bottomLeading, endPoint: .topTrailing))
                        Text("the Benefits")
                    }
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 56)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 72) {
                        VStack(alignment: .leading) {
                            Text("Circadian Rythm")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("Align your internal clock to nature, regulating sleep-wake cycles and hormone production.")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Morning Light")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("Morning light is highest in red and near-infrared wavelengths, supporting vitamin D and cellular energy production.")
                                .font(.callout)
                                .foregroundStyle(.secondary)

                        }
                        
                        VStack(alignment: .leading) {
                            Text("Mood & Producvitity")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Text("Light in the eyes increases serotonin and dopamine, enhancing mood, happyness, and a promoting calm energy.")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.bottom, 112)
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 48)
                .tag(1)
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Setting")
                            .foregroundStyle(LinearGradient(colors: [.yellow, .orange], startPoint: .bottomLeading, endPoint: .topTrailing))
                        Text("your alarm")
                    }
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 48)
                    Spacer()
                    
                    
                    VStack(alignment: .leading) {
                        Text("Notifications")
                            .font(.title3)
                            .fontWeight(.semibold)                        
                        Text("Notifications must be enabled to hear your alarm. Sunrise Alarm does not have to stay open.")
                            .foregroundStyle(.secondary)
                            .font(.callout)
                    }
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Volume")
                            .font(.title3)
                            .fontWeight(.semibold)                        
                        Text("Volume must be turned on. You can be reminded at night if your phone is silenced.")
                            .foregroundStyle(.secondary)
                            .font(.callout)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        Text("Do not Disturb")
                            .font(.title3)
                            .fontWeight(.semibold)
                        Text("If your phone is in Do not Disturb, Sunrise Alarm must be set as an allowed App.")
                            .foregroundStyle(.secondary)
                            .font(.callout)
                        
                        Text("Set Sunrise Alarm as an allowed app")
                            .foregroundStyle(.orange)
                            .font(.footnote)
                    }
                    .padding(.bottom, 112)
                    Spacer()
                }
                .padding(.horizontal, 48)
                .tag(2)
                
                ZStack {
                    
                    Button {
                        showOnboarding = false
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.bold)
                            .foregroundStyle(.black.opacity(0.3))
                            .padding(6)
                            .background(Circle().foregroundStyle(.bar.opacity(0.5)))
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.trailing, 24)
                    
                    VStack {
                        
                        Text("Start Now")
                            .font(.system(size: 36))
                            .fontWeight(.bold)
                            .foregroundStyle(LinearGradient(
                                gradient: Gradient(colors: [.orange, .yellow]),
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            ))
                            .padding(.top, 64)
                        
                        Spacer()
                        
                        Text("Your Free Week")
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .padding(.vertical, 12)
                            .multilineTextAlignment(.center)
                        
                        Text("7 days free. Cancel any time. Then $11.99/year ($0.99/month).")
                            .font(.callout)
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                        
                        Text("or $0.99/week")
                            .font(.footnote)
                            .foregroundStyle(.orange)
                            .padding(.bottom, 96)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 32)
                }
                .tag(3)
            }
            
            Button {
                if page == 3 {
                    showOnboarding = false
                    Task {
                        do {
                            try await PurchaseManager.shared.loadProducts()
                            try await PurchaseManager.shared.purchase(PurchaseManager.shared.products[0])
                        } catch {
                            print(error)
                        }
                    }
                } else {
                    withAnimation {
                        page += 1
                    }
                }
            } label: {
                Text(page == 3 ? "Try Free" : "Continue")
                    .foregroundStyle(.white)
                    .fontWeight(.medium)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 24).foregroundStyle(LinearGradient(colors: [.orange, .yellow.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)))                    .cornerRadius(24)
            }
            .padding(.horizontal, 32)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 52)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 32)
        .ignoresSafeArea()
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
    }
}

#Preview {
    Onboarding()
}
