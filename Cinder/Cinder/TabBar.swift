//
//  TabBar.swift
//  Cinder
//
//  Created by Jonah Blackmon on 7/27/25.
//
import SwiftUI

/*
    Custom Tab Bar allowing for seamless transition between various views
    Manages by the NavigationUIState primarily
 */

struct CustomTabBar: View {
    
    // [(Tab Name, System Icon)]
    var tabItems: [(String, String)]
    
    @State private var toggles: [String: (Bool, Bool)] = [:]
    
    @EnvironmentObject var navState: NavigationState
    @EnvironmentObject var settingsManager: SettingsManager
    
    var body: some View {
        VStack {
            HStack(spacing: 50) {
                ForEach(tabItems, id: \.0) { tab in
                    tabButton(for: tab)
                }
            }
            .padding(.vertical, 10)
            .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity)
        .animation(.easeInOut(duration: 0.1), value: navState.currentView)
        .frame(height: 30)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    @ViewBuilder
    private func tabButtonBackground(for tabName: String) -> some View {
        if navState.currentView == tabName {
            RoundedRectangle(cornerRadius: 20)
                .fill(settingsManager.accentColor.opacity(0.3))
                .frame(width: 75, height: 40)
        }
    }
    
    private func tabButton(for tab: (String, String)) -> some View {
        let (toggle, _) = toggles[tab.0, default: (false, false)]
        let animationDuration: Double = 0.3
        return (
            CustomButton(action: { handleTabTap(for: tab.0) }, content:
                        ZStack {
                            VStack {
                                tabButtonSystemIcon(tabName: tab.0, iconName: tab.1, toggles: $toggles)
                                    .environmentObject(navState)
                                    .environmentObject(settingsManager)
                                    .keyframeAnimator(initialValue: ButtonProperties(), trigger: toggle) {
                                        content, value in
                                        content
                                            .scaleEffect(value.scale)
                                            .scaleEffect(x: value.horizontalStretch)
                                            .scaleEffect(y: value.verticalStretch)
                                            .rotationEffect(Angle(degrees: value.rotation))
                                    } keyframes: { _ in
                                        KeyframeTrack(\.scale) {
                                            CubicKeyframe(0.75, duration: animationDuration * 0.35)
                                            CubicKeyframe(1, duration: animationDuration * 0.35)
                                            
                                        }
                                    }
                                tabButtonText(tab.0)
                                    .opacity(navState.currentView == tab.0 ? 1.0 : 0.6)
                            }
                        }
                    )
            .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: navState.currentView)
        )
    }
    
    private func tabButtonText(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 10))
            .foregroundStyle(settingsManager.accentColor)
    }

    struct tabButtonSystemIcon: View {
        var tabName: String
        var iconName: String
        @Binding var toggles: [String: (Bool, Bool)]
        @EnvironmentObject var navState: NavigationState
        @EnvironmentObject var settingsManager: SettingsManager
        var name: String {
            return navState.currentView == tabName ? iconName + "Clicked" : iconName
        }
        
        var body: some View {
            ZStack {
                Image(name)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                    .frame(width: 25, height: 25)
            }
        }
    }
    
    struct TabButtonProperties {
        var scale: Double = 1.0
        var horizontalStretch: Double = 1.0
        var verticalStretch: Double = 1.0
        var rotation: Double = 0.0
    }
    
    private func handleTabTap(for tabName: String) {
        let oldName = navState.currentView
        navState.currentView = tabName
        if navState.currentView != oldName {
            toggles[tabName, default: (false, false)].0.toggle()
            toggles[tabName, default: (false, false)].1 = true
            DispatchQueue.main.asyncAfter(deadline: .now() + ((tabName == "Map") ? 2.75 : 3.0)) {
                toggles[tabName, default: (false, false)].1 = false
            }
        }
    }
    
}


struct CustomButton<Content: View>: View {
    let action: () -> Void
    let content: Content
    var body: some View {
        ZStack {
            content
        }
        .onTapGesture {
            action()
        }
    }
}

#Preview {
    MainView()
        .environmentObject(NavigationState())
        .environmentObject(SettingsManager())
}
