//
//  HomeView.swift
//  Cinder
//
//  Created by Jonah Blackmon on 10/18/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var navState: NavigationState
    @StateObject private var cardController = CardStackController()
    @StateObject var imageService: CarImageService = CarImageService()
    var body: some View {
        ZStack {
            CardStack(controller: cardController)
                .environmentObject(settingsManager)
                .environmentObject(imageService)
            CardInteraction(controller: cardController)
                .environmentObject(settingsManager)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(NavigationState())
        .environmentObject(SettingsManager())
}
