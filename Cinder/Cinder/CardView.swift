//
//  CardView.swift
//  Cinder
//
//  Created by Jonah Blackmon on 10/18/25.
//

import SwiftUI
 
struct CardView: View {
    @State var car: Car? = nil
    @EnvironmentObject var imageService: CarImageService
    @EnvironmentObject var toyotaDB: ToyotaDatabase
    @State private var imageURL: String = ""
    @State var data: ToyotaVehicleData
    var body: some View {
        ZStack {
            Image("CardBG")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
                .frame(width: 300)
                .overlay(
                    VStack {
                        Spacer()
                        Text(car?.title ?? "")
                            .foregroundStyle(Color.beige)
                    }
                        .padding(.bottom, 50)
                        .padding(.trailing, 100)
                )
            Image("CarConstellation")
                .resizable()
                .scaledToFit()
                .ignoresSafeArea()
                .frame(width: 300)
                .clipped()
        }
        .frame(width: 100)
        .task {
            car = toyotaDB.convertToCar(data, matchReason: nil)
            imageURL = await imageService.fetchImage(for: car!)
        }
    }
}

#Preview {
    MainView()
        .environmentObject(NavigationState())
        .environmentObject(SettingsManager())
}
