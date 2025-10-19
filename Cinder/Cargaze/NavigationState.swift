//
//  NavigationState.swift
//  Cinder
//
//  Created by Jonah Blackmon on 10/18/25.
//
import SwiftUI
import Combine

// UI State vars to keep track of
class NavigationState: ObservableObject {
    
    @Published var currentView: String = "Home"
    @Published var currentCar: Car? = nil
}
