//
//  CardStackController.swift
//  Cinder
//

import SwiftUI
import Combine

class CardStackController: ObservableObject {
    
    @Published var swipeTrigger: (direction: SwipeDirection, id: UUID) = (.left, UUID())
    @Published var currentCar: Car? = nil
    func requestSwipe(_ direction: SwipeDirection) {
        swipeTrigger = (direction, UUID())
    }
}

enum SwipeDirection {
    case left, right
}
