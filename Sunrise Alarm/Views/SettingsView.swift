//
//  SoundView.swift
//  Sunrise Alarm
//  Created by Developer on 4/21/24.
//

import SwiftUI
import MessageUI
import TipKit

struct SunriseAlarmView: View {
    @State var model: Model
    @Environment(\.dismiss) var dismiss
    @Environment(\.requestReview) var requestReview
    @State var isShowingMailView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    Button {
                        model.showPaywall.toggle()
                    } label: {
                        Label("Unlock Pro", systemImage: "lock.open.fill")
                            .fontWeight(.medium)
                            .foregroundStyle(.white)
                            .padding(.vertical, 24)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .background(RoundedRectangle(cornerRadius: 24).foregroundStyle(LinearGradient(colors: [.red.opacity(0.8), .orange.opacity(0.8), .yellow.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)))
                .cornerRadius(24)
                .padding(.bottom, 28)
                .padding(.top, 24)
                
                // Support
                Text("Support")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                VStack(alignment: .leading, spacing: 16) {
                    Button {
                        requestReview()
                    } label: {
                        Label("Rate the App", systemImage: "star.fill")
                            .frame(height: 32)
                            .foregroundStyle(.orange)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Divider()
                    
                    ShareLink(item: URL(string: "https://apps.apple.com/us/app/light-speedometer/id6447198696")!) {
                        Label("Share", systemImage: "square.and.arrow.up")
                            .frame(height: 32)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
                .background(.black.opacity(0.3))
                .cornerRadius(24)
                .padding(.bottom, 28)
                
                // About
                Text("About")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Send Feedback
                    Button {
                        isShowingMailView.toggle()
                    } label: {
                        Label("Send Feedback", systemImage: "envelope.fill")
                            .frame(height: 32)
                            .foregroundStyle(.white)
                    }
                    
                    Divider()
                    
                    // Privacy & Terms
                    Link(destination: URL(string: "https://myflow.notion.site/Privacy-Policy-0002d1598beb401e9801a0c7fe497fd3?pvs=4")!) {
                        Label(
                            "Privacy & Terms", systemImage: "hand.raised.fill")
                        .frame(height: 32)
                        .foregroundStyle(.white)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(.black.opacity(0.3))
                .cornerRadius(24)
                
                VStack(spacing: 12) {
                    Text("Version 1.0")
                        .font(.caption)
                        .foregroundStyle(.orange)
                    
                    Text("Developed by")
                        .font(.footnote)
                        .foregroundStyle(.tertiary)
                    
                    Text("Nate Tedesco")
                        .font(.callout)
                        .foregroundStyle(.tertiary)
                }
                .padding(.top, 2)
            }
            .navigationTitle("Sunrise Alarm")
            .navigationBarTitleDisplayMode(.inline)
            .padding(.horizontal, 24)
            .accentColor(.orange)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundStyle(.black.opacity(0.3))
                            .padding(8)
                            .background(Circle().foregroundStyle(.regularMaterial))
                            .padding(.top, 4)
                    }
                }
            }
            .sheet(isPresented: $model.showPaywall) {
                Paywall()
                    .presentationDetents([.fraction(4/10)])
                    .presentationCornerRadius(40)
                    .presentationBackground(.regularMaterial)
            }
            .sheet(isPresented: $isShowingMailView) {
                MailComposeViewControllerWrapper(isShowing: $isShowingMailView)
                    .ignoresSafeArea()
            }
        }
    }
}

struct MailComposeViewControllerWrapper: UIViewControllerRepresentable {
    @Binding var isShowing: Bool
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = context.coordinator
        mailComposeVC.setToRecipients(["natetedesco@icloud.com"])
        mailComposeVC.setSubject("Sunrise Alarm")
        mailComposeVC.setMessageBody("", isHTML: false)
        return mailComposeVC
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isShowing: $isShowing)
    }
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var isShowing: Bool
        
        init(isShowing: Binding<Bool>) {
            _isShowing = isShowing
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            isShowing = false
        }
    }
}

#Preview {
    ContentView(model: Model())
        .sheet(isPresented: .constant(true)) {
            SunriseAlarmView(model: Model())
                .presentationBackground(.regularMaterial)
                .presentationCornerRadius(40)
        }
}
