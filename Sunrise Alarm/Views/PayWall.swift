//
//  PayWall.swift
//  Sunrise Alarm
//
//  Created by Developer on 4/23/24.
//

import SwiftUI
import StoreKit

struct PayWall: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var purchaseManager = PurchaseManager()

    var body: some View {
        VStack {
            Text("Unlock Everything")
                .font(.title)
                .fontWeight(.bold)
            
            Spacer()
            
            Text("7 days free, Cancel anytime. Then $11.99/year($0.99/month)")
                .font(.callout)
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button {
                dismiss()
                Task {
                    do {
                        try await purchaseManager.loadProducts()
                        try await purchaseManager.purchase(purchaseManager.products[0])
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Try Free")
                    .foregroundStyle(.white)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .background(RoundedRectangle(cornerRadius: 24).foregroundStyle(LinearGradient(colors: [.orange, .yellow.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)))                        
                    .cornerRadius(24)
            }
            .padding(.top, 8)
            .padding(.bottom)
            
            HStack {
                Button {
                    if let url = URL(string: "https://myflow.notion.site/Sunrise-Alarm-Privacy-Policy-bfd5661827074abbae5855326a4f4d35?pvs=4") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    Text("Terms • Privacy")
                }
                
                Button {
                    Task { do { try await AppStore.sync() } catch { print(error) }}
                } label: {
                    Text("• Restore")
                }
                .padding(.leading, -6)
            }
            .font(.caption)
            .foregroundStyle(.tertiary)
            .fontWeight(.medium)
        }
        .padding(.horizontal, 32)
        .padding(.top, 24)
    }
}

#Preview {
    ContentView(alarm: AlarmModel())
        .sheet(isPresented: .constant(true)) {
            PayWall()
                .presentationDetents([.fraction(4/10)])
                .presentationCornerRadius(40)
                .presentationBackground(.regularMaterial)
        }
}
