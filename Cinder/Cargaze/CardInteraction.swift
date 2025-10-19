//
//  CardInteraction.swift
//  Cinder
//
//  Created by Jonah Blackmon on 10/18/25.
//

import SwiftUI

struct CardInteraction: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var navState: NavigationState
    @ObservedObject var controller: CardStackController
    @State var toggle1: Bool = false
    @State var toggle2: Bool = false
    @State var toggle3: Bool = false
    let animationDuration: Double = 1.0
    var body: some View {
        HStack {
            if (!settingsManager.leftHanded) {
                Spacer()
            }
            VStack {
                Button {
                    toggle1.toggle()
                    controller.requestSwipe(.left)
                } label: {
                    AccentedButton(imageName: "DislikeButton")
                }
                .keyframeAnimator(initialValue: ButtonProperties(), trigger: toggle1) {
                    content, value in
                    content
                        .scaleEffect(value.scale)
                        .scaleEffect(x: value.horizontalStretch)
                        .scaleEffect(y: value.verticalStretch)
                        .rotationEffect(Angle(degrees: value.rotation))
                } keyframes: { _ in
                    KeyframeTrack(\.scale) {
                        SpringKeyframe(0.75, duration: animationDuration * 0.35)
                        SpringKeyframe(1, duration: animationDuration * 0.35)
                        
                    }
                }
                Button {
                    toggle2.toggle()
                    navState.currentCar = controller.currentCar
                } label: {
                    AccentedButton(imageName: "FlipButton")
                }
                .keyframeAnimator(initialValue: ButtonProperties(), trigger: toggle2) {
                    content, value in
                    content
                        .scaleEffect(value.scale)
                        .scaleEffect(x: value.horizontalStretch)
                        .scaleEffect(y: value.verticalStretch)
                        .rotationEffect(Angle(degrees: value.rotation))
                } keyframes: { _ in
                    KeyframeTrack(\.scale) {
                        SpringKeyframe(0.75, duration: animationDuration * 0.35)
                        SpringKeyframe(1, duration: animationDuration * 0.35)
                        
                    }
                }
                Button {
                    toggle3.toggle()
                    controller.requestSwipe(.right)
                } label: {
                    AccentedButton(imageName: "LikeButton")
                }
                .keyframeAnimator(initialValue: ButtonProperties(), trigger: toggle3) {
                    content, value in
                    content
                        .scaleEffect(value.scale)
                        .scaleEffect(x: value.horizontalStretch)
                        .scaleEffect(y: value.verticalStretch)
                        .rotationEffect(Angle(degrees: value.rotation))
                } keyframes: { _ in
                    KeyframeTrack(\.scale) {
                        SpringKeyframe(0.75, duration: animationDuration * 0.35)
                        SpringKeyframe(1, duration: animationDuration * 0.35)
                        
                    }
                }
            }
            .padding()
            if (settingsManager.leftHanded) {
                Spacer()
            }
        }
    }
}

struct ButtonProperties {
    var scale: Double = 1.0
    var horizontalStretch: Double = 1.0
    var verticalStretch: Double = 1.0
    var rotation: Double = 0.0
}
#Preview {
    MainView()
        .environmentObject(NavigationState())
        .environmentObject(SettingsManager())
}
