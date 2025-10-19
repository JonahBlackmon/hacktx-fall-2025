//
//  MainView.swift
//  Cinder
//
//  Created by Jonah Blackmon on 10/18/25.
//

import SwiftUI

struct MainView: View {
    
    @EnvironmentObject var navState: NavigationState
    @EnvironmentObject var settingsManager: SettingsManager
    
    let tabBar: [(String, String)] = [("Home", "car"), ("Likes", "heart"), ("Profile", "person")]
    
    var body: some View {
        mainView
    }
    
    @ViewBuilder
    private var currentViewContent: some View {
        switch navState.currentView {
        case "Home":
            HomeView()
                .environmentObject(navState)
                .environmentObject(settingsManager)
        case "Likes":
            LikedView()
                .environmentObject(navState)
                .environmentObject(settingsManager)
        case "Profile":
            ProfileView()
                .environmentObject(navState)
                .environmentObject(settingsManager)
        default:
            HomeView()
                .environmentObject(navState)
                .environmentObject(settingsManager)
        }
    }
    
    
    private var mainView: some View {
        ZStack() {
            Color.darkBlue
                .ignoresSafeArea()
            Image("StarBG")
                .resizable()
                .ignoresSafeArea()
            currentViewContent
            BackgroundAccents()
                .allowsHitTesting(false)
            CustomTabBar(tabItems: tabBar)
                .environmentObject(navState)
                .environmentObject(settingsManager)
        }
        .sheet(item: $navState.currentCar) { car in
            CarDetailSheetView(
                car: car
            )
        }
    }
}

struct EnhancedToyotaCardDetailSheetView: View {
    let car: Car
    let compact: Bool
    let income: String?
    let creditScore: String?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(car.title)
                    .font(.title2).bold()
                Spacer()
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.top)

            Form {
                Section(header: Text("Specifications")) {
                    HStack { Text("Car type"); Spacer(); Text(car.carType).foregroundColor(.secondary) }
                    HStack { Text("Fuel type"); Spacer(); Text(car.fuelType).foregroundColor(.secondary) }
                    HStack { Text("MPG"); Spacer(); Text(car.mpg).foregroundColor(.secondary) }
                    HStack { Text("Range"); Spacer(); Text(car.range).foregroundColor(.secondary) }
                    HStack { Text("Seating"); Spacer(); Text(car.seating).foregroundColor(.secondary) }
                    HStack { Text("Horsepower"); Spacer(); Text("\(car.horsepower) HP").foregroundColor(.secondary) }
                    HStack { Text("Transmission"); Spacer(); Text(car.transmission).foregroundColor(.secondary) }
                    HStack { Text("Color"); Spacer(); Text(car.color).foregroundColor(.secondary) }
                }
                
                Section(header: Text("Description")) {
                    Text(car.description)
                }
                
                if let matchReason = car.matchReason {
                    Section(header: Text("Why This Matches")) {
                        Text(matchReason)
                            .foregroundColor(.blue)
                    }
                }
                
                // NEW: Financing Section
                Section(header: Text("Financing Options")) {
                    FinancingPlanView(car: car, income: income, creditScore: creditScore)
                }
            }
        }
        .presentationDetents([.large])
    }
}

struct testView: View {
    @EnvironmentObject var navState: NavigationState
    @EnvironmentObject var settingsManager: SettingsManager
    var body: some View {
        Text(navState.currentView)
            .foregroundStyle(settingsManager.accentColor)
    }
}

#Preview {
    MainView()
        .environmentObject(NavigationState())
        .environmentObject(SettingsManager())
}
