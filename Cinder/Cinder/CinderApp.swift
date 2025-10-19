//
//  CinderApp.swift
//  Cinder
//
//  Created by Parth Mehta on 10/18/25.
//

import SwiftUI
import SwiftData

@main
struct CinderApp: App {
    @StateObject var settingsManager: SettingsManager = SettingsManager()
    @StateObject var navState: NavigationState = NavigationState()
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(settingsManager)
                .environmentObject(navState)
        }
        .modelContainer(sharedModelContainer)
    }
}
