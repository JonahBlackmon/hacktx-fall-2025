//
//  LikedView.swift
//  Cinder
//
//  Created by Jonah Blackmon on 10/19/25.
//

import SwiftUI

struct LikedView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @EnvironmentObject var navState: NavigationState
    
    var body: some View {
        ZStack {
            
            // Semi-transparent overlay to dim the background
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            // Celestial stars and particles overlay
            GeometryReader { geometry in
                ForEach(0..<50, id: \.self) { index in
                    Circle()
                        .fill(
                            index % 3 == 0 ? Color.white.opacity(Double.random(in: 0.4...0.8)) :
                                index % 3 == 1 ? Color.blue.opacity(Double.random(in: 0.3...0.6)) :
                                Color.purple.opacity(Double.random(in: 0.3...0.6))
                        )
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .blur(radius: index % 5 == 0 ? 0 : 1)
                }
            }
            
            if settingsManager.likedCars.isEmpty {
                // Empty state
                VStack(spacing: 20) {
                    ZStack {
                        // Celestial glow
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.3))
                            .blur(radius: 20)
                        
                        Image(systemName: "heart.slash")
                            .font(.system(size: 60))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .blue.opacity(0.8), .purple.opacity(0.7)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    
                    Text("No Liked Cars Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.95))
                        .shadow(color: .black.opacity(0.5), radius: 2)
                    
                    Text("Start swiping to discover your perfect match")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .shadow(color: .black.opacity(0.5), radius: 2)
                }
                .padding(.top, 100)
            } else {
                ScrollView {
                    VStack {
                        HStack {
                            Text("Liked Cars")
                                .bold()
                                .frame(alignment: .leading)
                                .font(.system(size: 20))
                                .foregroundStyle(settingsManager.accentColor)
                                .padding()
                            Spacer()
                        }
                        Spacer()
                    }
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ],
                        spacing: 16
                    ) {
                        ForEach(Array(settingsManager.likedCars.values), id: \.id) { car in
                            LikedCarCell(car: car)
                                .environmentObject(navState)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
    }
}

struct LikedCarCell: View {
    let car: Car
    @State private var isPressed = false
    @EnvironmentObject var navState: NavigationState
    var body: some View {
        VStack(spacing: 0) {
            // Celestial card with glass effect
            ZStack {
                // Outer celestial glow
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.1),
                                Color.blue.opacity(0.2),
                                Color.purple.opacity(0.2)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blur(radius: 10)
                    .padding(-6)
                
                // Card background with glass effect
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        Color.white.opacity(0.05)
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.1, green: 0.1, blue: 0.2).opacity(0.6),
                                        Color(red: 0.05, green: 0.05, blue: 0.15).opacity(0.7)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .blur(radius: 20)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.3),
                                        Color.blue.opacity(0.3),
                                        Color.purple.opacity(0.3),
                                        Color.white.opacity(0.3)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                
                VStack(spacing: 12) {
                    // Car icon with celestial glow
                    ZStack {
                        // Multiple glow layers for starlight effect
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 70, height: 70)
                            .blur(radius: 15)
                        
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.blue.opacity(0.3),
                                        Color.purple.opacity(0.2),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 35
                                )
                            )
                            .frame(width: 70, height: 70)
                        
                        Image(systemName: "car.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .blue.opacity(0.9), .purple.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .shadow(color: .white.opacity(0.5), radius: 5)
                    }
                    .padding(.top, 16)
                    
                    // Car info
                    VStack(spacing: 6) {
                        Text(car.title)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.95))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                            .shadow(color: .black.opacity(0.5), radius: 1)
                        
                        Text("$\(car.price)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .blue.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: .black.opacity(0.5), radius: 1)
                        
                        // Celestial divider with star pattern
                        HStack(spacing: 4) {
                            ForEach(0..<3) { _ in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 4))
                                    .foregroundColor(.white.opacity(0.4))
                            }
                        }
                        .padding(.vertical, 4)
                        
                        // Key specs
                        VStack(spacing: 4) {
                            SpecRow(icon: "fuelpump.fill", text: car.fuelType)
                            SpecRow(icon: "gauge.medium", text: car.mpg)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 16)
                }
            }
            .aspectRatio(0.7, contentMode: .fit)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .shadow(
                color: Color.white.opacity(0.2),
                radius: 10,
                x: 0,
                y: 5
            )
        }
        .onTapGesture {
            isPressed = true
            navState.currentCar = car
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isPressed = false
            }
        }
    }
}

struct SpecRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 10))
                .foregroundColor(.blue.opacity(0.7))
            
            Text(text)
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    MainView()
        .environmentObject(NavigationState())
        .environmentObject(SettingsManager())
}
