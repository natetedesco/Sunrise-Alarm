//
//  SoundView.swift
//  Sunrise Alarm
//  Created by Developer on 4/21/24.
//

import SwiftUI
import MessageUI

struct SettingsView: View {
    @Environment(Model.self) var model
    
    @State var isShowingMailView = false
    @State var purchases = Purchases.shared
    @Environment(\.requestReview) var requestReview
    
    var privacyPolicy = "https://myflow.notion.site/Privacy-Policy-0002d1598beb401e9801a0c7fe497fd3?pvs=4"
    var shareLink = "https://apps.apple.com/us/app/light-speedometer/id6447198696"
    
    var body: some View {
        @Bindable var model = model
        
        NavigationView {
            ScrollView {
                if !model.purchases.proAccess { getProButton }
                
#if DEBUG
                Toggle(isOn: $model.purchases.proAccess) { Text("Pro Access") }
                    .toggleStyle(SwitchToggleStyle(tint: Color.orange))
                    .frame(height: 36)
                    .customBackground()
                    .padding(.bottom, 28)
#endif
                
                // About
                Headline(text: "About")
                Card {
                    Button {
                        requestReview()
                    } label: {
                        Label("Rate the App", systemImage: "star.fill")
                            .frame(height: 32)
                            .foregroundStyle(.orange)
                    }
                    
                    Divider()
                    
                    ShareLink(item: URL(string: shareLink)!) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .frame(height: 32)
                    }
                }
                
                .padding(.bottom, 28)
                
                // About
                Headline(text: "About")
                Card {
                    // Feedback
                    Button {
                        isShowingMailView.toggle()
                    } label: {
                        Label("Send Feedback", systemImage: "envelope.fill")
                            .frame(height: 32)
                            .foregroundStyle(.white)
                    }
                    
                    Divider()
                    
                    // Privacy & Terms
                    Link(destination: URL(string: privacyPolicy)!) {
                        Label(
                            "Privacy & Terms", systemImage: "hand.raised.fill")
                        .frame(height: 32)
                        .foregroundStyle(.white)
                    }
                }
                
                VStack(spacing: 12) {
                    Text("Version 1.0")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                        .padding(.top, 8)
                    Text("Developed by Nate Tedesco")
                        .font(.footnote)
                        .foregroundStyle(.tertiary)
                        .padding(.top, 4)
                    
                }
                .padding(.top, 2)
            }
            .navigationTitle("Sunrise Alarm")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal, 24)
            .sheet(isPresented: $isShowingMailView) {
                MailComposeViewControllerWrapper(isShowing: $isShowingMailView)
                    .ignoresSafeArea()
            }
            .sheet(isPresented: $model.purchases.showPaywall) {
                Paywall()
                    .presentationDetents([.fraction(4/10)])
                    .presentationCornerRadius(40)
                    .presentationBackground(.regularMaterial)
            }
        }
    }
    
    var getProButton: some View {
        Button {
            Task {
                do {
                    try await purchases.loadProducts()
                    try await purchases.purchase(purchases.products[0])
                } catch {
                    print(error)
                }
            }
            lightHaptic()
        } label: {
            Label("Unlock Pro", systemImage: "lock.fill")
                .fontWeight(.medium)
                .foregroundStyle(.white)
                .padding(.vertical, 22)
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.red.opacity(0.8), .orange.opacity(0.8), .yellow.opacity(0.8)],
                                startPoint: .topLeading, endPoint: .bottomTrailing))
                )
                .cornerRadius(24)
                .padding(.bottom, 28)
                .padding(.top, 24)
        }
    }
}

struct MailComposeViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator(isShowing: $isShowing) }
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = context.coordinator
        mailComposeVC.setToRecipients(["natetedesco@icloud.com"])
        mailComposeVC.setSubject("Sunrise Alarm")
        mailComposeVC.setMessageBody("", isHTML: false)
        return mailComposeVC
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        isShowing = false
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool
        init(isShowing: Binding<Bool>) {
            _isShowing = isShowing
        }
    }
}

#Preview {
    ContentView()
        .sheet(isPresented: .constant(true)) {
            SettingsView()
                .presentationBackground(.regularMaterial)
                .presentationCornerRadius(40)
        }
}
