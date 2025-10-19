//
//  HeaderView.swift
//  Cinder
//
//  Created by Jonah Blackmon on 10/19/25.
//
import SwiftUI

struct HeaderView: View {
    let animationDuration: Double = 1.0
    @State var toggle: Bool = false
    var body: some View {
        VStack {
            HStack {
                Image("AppName")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                    .frame(width: 150, height: 150)
                    .padding(.leading, 45)
                    .scaleEffect(1.2)
                Spacer()
                Button {
                    toggle.toggle()
                } label: {
                    AccentedButton(imageName: "WheelButton")
                        .padding()
                }
                .keyframeAnimator(initialValue: ButtonProperties(), trigger: toggle) {
                    content, value in
                    content
                        .scaleEffect(value.scale)
                        .scaleEffect(x: value.horizontalStretch)
                        .scaleEffect(y: value.verticalStretch)
                        .rotationEffect(Angle(degrees: value.rotation))
                        .offset(y: -35)
                } keyframes: { _ in
                    KeyframeTrack(\.scale) {
                        SpringKeyframe(0.75, duration: animationDuration * 0.35)
                        SpringKeyframe(1, duration: animationDuration * 0.35)
                        
                    }
                    KeyframeTrack(\.rotation) {
                        CubicKeyframe(360, duration: animationDuration * 0.6)
                    }
                }
//                .scaleEffect(1.4)
            }
            Spacer()
        }
    }
}

#Preview {
    MainView()
        .environmentObject(NavigationState())
        .environmentObject(SettingsManager())
}
