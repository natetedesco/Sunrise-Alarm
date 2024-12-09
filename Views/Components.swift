//
//  Components.swift
//  Sunrise AlarmTests
//  Created by Developer on 12/6/24.
//

import SwiftUI

// View Modifiers
extension View {
    func thinSheetBackground() -> some View {
        self
            .presentationCornerRadius(40)
            .presentationBackground(.thinMaterial)
    }
    func smallSheetBackground() -> some View {
        self
            .presentationDetents([.fraction(CGFloat(3/10))])
            .presentationCornerRadius(40)
            .presentationBackground(.regularMaterial)
    }
}

struct AlarmSet: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("Alarm is Set!")
                .font(.title2)
                .fontWeight(.semibold)
            Spacer()
            Text("Make sure your volume is on. See you tomorrow!")
                .font(.title3)
                .fontWeight(.medium)
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
