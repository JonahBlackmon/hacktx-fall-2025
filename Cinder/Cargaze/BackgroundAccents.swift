//
//  BackgroundAccents.swift
//  Cinder
//
//  Created by Jonah Blackmon on 10/18/25.
//
import SwiftUI

struct BackgroundAccents: View {
    var body: some View {
        Image("TabBarBG")
            .resizable()
            .scaledToFit()
            .ignoresSafeArea()
            .offset(y: 43)
    }
}

#Preview {
    MainView()
        .environmentObject(NavigationState())
        .environmentObject(SettingsManager())
}
