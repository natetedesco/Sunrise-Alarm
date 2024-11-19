//
//  SwiftUIView.swift
//  Sunrise Alarm
//  Created by Developer on 4/23/24.
//

import SwiftUI

struct WakeUpView: View {
    @State var model: Model
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Text("Rise and Shine")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom)
                Text("Snooze")
                    .font(.title3)
                    .fontWeight(.medium)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(.orange)
                    .cornerRadius(40)
                Spacer()
            }
            Button {
                model.showWakeUp = false
            } label: {
                Text("Stop")
                    .font(.title)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 64)
                    .padding(.vertical)
                    .background(.regularMaterial)
                    .cornerRadius(32)
                    .padding(.bottom)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    WakeUpView(model: Model())
}
