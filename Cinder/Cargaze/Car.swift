//
//  Car.swift
//  Cinder
//
//  Created by Jonah Blackmon on 10/18/25.
//
import SwiftUI

struct Car: Identifiable, Codable {
    let id = UUID()
    let model: String
    let year: Int
    let carType: String
    let fuelType: String
    let mpg: String
    let range: String
    let seating: String
    let price: Int
    let horsepower: Int
    let transmission: String
    let color: String
    let description: String
    let matchReason: String?
    let imageURL: String?
    
    // Helper computed property for display
    var title: String { "\(year) Toyota \(model)" }
    
    enum CodingKeys: String, CodingKey {
        case model, year, carType, fuelType, mpg, range, seating
        case price, horsepower, transmission, color, description
        case matchReason, imageURL
    }
}
