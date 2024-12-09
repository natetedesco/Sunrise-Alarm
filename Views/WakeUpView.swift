//
//  SwiftUIView.swift
//  Sunrise Alarm
//  Created by Developer on 4/23/24.
//

import SwiftUI

struct WakeUpView: View {
    @Environment(Model.self) var model
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        ZStack {
            VStack {
                Button {
                    
                } label: {
                    Text("Snooze")
                        .foregroundStyle(.white)
                        .fontWeight(.medium)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(.bar)
                        .cornerRadius(40)
                }
                .padding(.top)
                Spacer()
                Text("Rise and Shine")
                    .font(.system(size: 44))
                    .fontWeight(.semibold)
                    .padding(.bottom, 48)
                
                Spacer()
            }
            Button {
                model.stopAlarm()
                requestReview()
            } label: {
                Text("Stop")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 64)
                    .padding(.vertical)
                    .background(.orange)
                    .cornerRadius(32)
                    .padding(.bottom)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    WakeUpView()
}
