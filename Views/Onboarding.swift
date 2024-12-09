//
//  Onboarding.swift
//  Sunrise Alarm
//  Created by Developer on 4/21/24.
//

import SwiftUI

struct Onboarding: View {
    @Environment(Model.self) var model

    @State var purchases = Purchases.shared
    @State var page: OnboardingPage = .location
    
    var body: some View {
        ZStack {
            TabView(selection: .init(
                get: { page.rawValue },
                set: { page = OnboardingPage(rawValue: $0) ?? .location }
            )) {
                // Rise with the sun
                VStack(alignment: .leading) {
                    onboardingTitle(title1: "Rise", title2: "with the sun")
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 72) {
                        OnboardingSection(
                            title: "Circadian Rythm",
                            text: "Align your internal clock to nature, regulating sleep-wake cycles and hormone production."
                        )
                        
                        OnboardingSection(
                            title: "Morning Light",
                            text: "Morning light is highest in red and near-infrared wavelengths, supporting vitamin D and cellular energy production."
                        )
                        
                        OnboardingSection(
                            title: "Mood & Producvitity",
                            text: "Light in the eyes increases serotonin and dopamine, enhancing mood, happyness, and a promoting calm energy."
                        )
                    }
                    .padding(.bottom, 112)
                    
                    Spacer()
                }
                .padding(.horizontal, 48)
                .tag(OnboardingPage.location.rawValue)
                
                // Setting your alarm
                VStack(alignment: .leading) {
                    onboardingTitle(title1: "Setting", title2: "your alarm")
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 72) {
                        OnboardingSection(
                            title: "Notifications",
                            text: "Notifications must be enabled to hear your alarm. Sunrise Alarm does not have to stay open."
                        )
                        
                        OnboardingSection(
                            title: "Volume",
                            text: "You will not hear your alarm if your phone is in silent mode. You can be notified at night to turn volume on."
                        )
                        
                        VStack(alignment: .leading) {
                            OnboardingSection(
                                title: "Do not Disturb",
                                text: "If your phone is in Sleep mode or Do not Disturb, Sunrise Alarm must be an allowed App."
                            )
                            
                            Button {
                                UNUserNotificationCenter.current().requestAuthorization(options:[.sound,.alert]) { (_, _) in }
                                if let url = URL(string: "App-prefs:com.apple.DND") {
                                    UIApplication.shared.open(url)
                                }
                            } label: {
                                Text("Set as an allowed app")
                                    .foregroundStyle(.orange)
                                    .font(.callout)
                            }
                        }
                    }
                    .padding(.bottom, 112)
                    
                    Spacer()
                }
                .padding(.horizontal, 48)
                .tag(OnboardingPage.notifications.rawValue)
                
                // Third Page
                ZStack {
                    Button {
                        purchases.showOnboarding = false
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.heavy)
                            .foregroundStyle(.black.opacity(0.6))
                            .padding(6)
                            .background(Circle().foregroundStyle(.ultraThinMaterial))
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
                .tag(OnboardingPage.pricing.rawValue)
            }
            
            Button {
                switch page {
                case .location:
                    Task {
                        model.locationService.requestLocationPermissionIfNeeded()
                    }
                    withAnimation {
                        page = .notifications
                    }
                case .notifications:
                    UNUserNotificationCenter.current().requestAuthorization(options:[.sound,.alert]) { (_, _) in }
                    withAnimation {
                        page = .pricing
                    }
                case .pricing:
                    Task {
                        do {
                            try await purchases.loadProducts()
                            try await purchases.purchase(purchases.products[0])
                        } catch {
                            print(error)
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        purchases.showOnboarding = false
                    }
                }
            } label: {
                Text(page.buttonTitle)
                    .foregroundStyle(.white)
                    .fontWeight(.medium)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(RoundedRectangle(cornerRadius: 24).foregroundStyle(LinearGradient(colors: [.orange, .yellow.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)))
                    .cornerRadius(24)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.horizontal, 32)
            .padding(.bottom, 52)
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .never))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 32)
        .ignoresSafeArea()
    }
}

struct OnboardingCard<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            content
            Spacer()
        }
    }
}

struct onboardingTitle: View {
    var title1: String
    var title2: String
    
    var body: some View {
        HStack{
            Text(title1)
                .foregroundStyle(LinearGradient(colors: [.yellow, .orange], startPoint: .bottomLeading, endPoint: .topTrailing))
            Text(title2)
        }
        .font(.largeTitle)
        .fontWeight(.bold)
        .multilineTextAlignment(.center)
        .padding(.top, 48)
    }
}

struct OnboardingSection: View {
    var title: String
    var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
            Text(text)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
    }
}

enum OnboardingPage: Int {
    case location = 0
    case notifications = 1
    case pricing = 2
    
    var buttonTitle: String {
        switch self {
        case .location: return "Allow Location Access"
        case .notifications: return "Allow Notifications"
        case .pricing: return "Continue"
        }
    }
}

#Preview {
    Onboarding()
}
