//
//  CardStack.swift
//  Cinder
//
//  Created by Jonah Blackmon on 10/18/25.
//

import SwiftUI

struct CardStack: View {
    @State var topCardIndex: Int = 0
    @State var dragOffset: CGSize = .zero
    @EnvironmentObject var settingsManager: SettingsManager
    @ObservedObject var controller: CardStackController
    @EnvironmentObject var imageService: CarImageService
    @StateObject var toyotaDB = ToyotaDatabase()
    @State var cards: [ToyotaVehicleData] = []
    
    var body: some View {
        ZStack {
            ForEach(Array(cards.prefix(3).enumerated()), id: \.element.id) { index, card in
                createCardView(for: card, at: index)
            }
        }
        .onChange(of: controller.swipeTrigger.id) { _, _ in
            performSwipe(direction: controller.swipeTrigger.direction)
        }
        .onAppear() {
            cards = toyotaDB.vehicles
            if !cards.isEmpty {
                controller.currentCar = toyotaDB.convertToCar(cards[topCardIndex])
            }
        }
    }
    
    // Extract the card view creation into a separate method
    @ViewBuilder
    private func createCardView(for card: ToyotaVehicleData, at index: Int) -> some View {
        let visualIndex = index
        let progress = min(abs(dragOffset.width) / 150, 1)
        let signedProgress = (dragOffset.width >= 0 ? 1 : -1) * progress
        
        // Calculate transforms
        let xOffset = visualIndex == 0 ? dragOffset.width : Double(visualIndex) * 10
        let yOffset = visualIndex == 0 ? 0 : Double(visualIndex) * -4
        let zIndex = Double(cards.count - visualIndex)
        let rotation = visualIndex == 0 ? 0 : Double(visualIndex) * 3 - progress * 3
        let scale = calculateScale(for: visualIndex, progress: progress)
        let xOffsetAdjustment = visualIndex == 0 ? 0 : Double(visualIndex) * -3
        let rotation3D = (visualIndex == 0 || visualIndex == 1) ? 10 * signedProgress : 0
        
        CardView(data: card)
            .environmentObject(toyotaDB)
            .environmentObject(imageService)
            .offset(x: xOffset, y: yOffset)
            .zIndex(zIndex)
            .rotationEffect(.degrees(rotation), anchor: .bottom)
            .scaleEffect(scale)
            .offset(x: xOffsetAdjustment)
            .rotation3DEffect(.degrees(rotation3D), axis: (0, 1, 0))
            .transition(.asymmetric(
                insertion: .scale(scale: 0.82).combined(with: .offset(x: -9, y: -8)),
                removal: .identity
            ))
            .id(card.id)
            .contentShape(Rectangle())
            .gesture(createDragGesture())
    }
    
    // Helper function for scale calculation
    private func calculateScale(for visualIndex: Int, progress: Double) -> Double {
        if visualIndex == 0 {
            return 1.0
        } else if visualIndex == 1 {
            return 1.0 - Double(visualIndex) * 0.06 + progress * 0.06
        } else {
            return 1.0 - Double(visualIndex) * 0.06
        }
    }
    
    // Extract drag gesture into a separate method
    private func createDragGesture() -> some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                let threshold: CGFloat = 50
                let direction: CGFloat = value.translation.width > 0 ? 1 : -1
                if abs(value.translation.width) > threshold {
                    performSwipe(direction: direction > 0 ? .right : .left)
                } else {
                    withAnimation {
                        dragOffset = .zero
                    }
                }
            }
    }
    
    // Add this function to handle both drag and button swipes
    func performSwipe(direction: SwipeDirection) {
        guard !cards.isEmpty else { return }
        
        let directionMultiplier: CGFloat = direction == .right ? 1 : -1
        
        withAnimation(.smooth(duration: 0.2)) {
            dragOffset.width = directionMultiplier * 500
        }

        let swiped = cards[topCardIndex]
        let swipedCar = toyotaDB.convertToCar(swiped)
        let ref = swipedCar.title

        if direction == .right {
            settingsManager.writeLike(swipedCar, ref: ref)
        } else {
            settingsManager.writeDislike(swipedCar, ref: ref)
        }

        // Reset and remove the card
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.smooth(duration: 0.3)) {
                dragOffset = .zero
                if !cards.isEmpty {
                    cards.remove(at: topCardIndex)
                    if topCardIndex >= cards.count {
                        topCardIndex = 0
                    }
                    if cards.count > 0 {
                        controller.currentCar = toyotaDB.convertToCar(cards[topCardIndex])
                    }
                }
            }
        }
    }
}

//#Preview {
//    CardStack()
//}
