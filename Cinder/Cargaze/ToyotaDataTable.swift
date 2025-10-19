// ToyotaDataTable.swift
// Add this as a new file to your project

import Foundation
import Combine

// MARK: - Toyota Vehicle Data Table
struct ToyotaVehicleData: Identifiable {
    let id = UUID()
    let year: Int
    let make: String
    let model: String
    let trim: String
    let price: Int
    let carType: String
    let fuelType: String
    let mpg: String
    let range: String
    let seating: String
    let horsepower: Int
    let transmission: String
    let color: String
    let description: String
}

// MARK: - Complete Toyota Vehicle Database (2023-2024)
class ToyotaDatabase: ObservableObject {
    
    static let shared = ToyotaDatabase()
    
    let vehicles: [ToyotaVehicleData] = [
        // 2023 Camry
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Camry", trim: "LE", price: 26320, carType: "Sedan", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 203, transmission: "Automatic", color: "Silver", description: "Reliable midsize sedan with excellent fuel economy and comfortable ride."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Camry", trim: "SE", price: 27980, carType: "Sedan", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 203, transmission: "Automatic", color: "Red", description: "Sporty Camry with upgraded styling and handling dynamics."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Camry", trim: "XLE", price: 31220, carType: "Sedan", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 203, transmission: "Automatic", color: "Black", description: "Premium Camry with luxury features and refined interior."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Camry", trim: "TRD", price: 32320, carType: "Sedan", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 301, transmission: "Automatic", color: "White", description: "Performance-tuned Camry with sport suspension and aggressive styling."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Camry Hybrid", trim: "LE", price: 28855, carType: "Sedan", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 208, transmission: "Automatic", color: "Blue", description: "Fuel-efficient hybrid sedan with excellent city MPG."),
        
        // 2024 Camry
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Camry", trim: "LE", price: 27025, carType: "Sedan", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 203, transmission: "Automatic", color: "Gray", description: "Updated Camry with refined design and modern tech features."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Camry", trim: "SE", price: 28605, carType: "Sedan", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 203, transmission: "Automatic", color: "Red", description: "Sport-focused Camry with dynamic handling and sleek appearance."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Camry", trim: "XSE", price: 31605, carType: "Sedan", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 301, transmission: "Automatic", color: "Black", description: "Premium sport sedan combining luxury with performance."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Camry Hybrid", trim: "LE", price: 29495, carType: "Sedan", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 208, transmission: "Automatic", color: "Silver", description: "Eco-friendly sedan with impressive fuel economy."),
        
        // 2023 Corolla
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Corolla", trim: "L", price: 21550, carType: "Sedan", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 139, transmission: "Automatic", color: "White", description: "Affordable compact sedan with proven reliability."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Corolla", trim: "LE", price: 22945, carType: "Sedan", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 139, transmission: "Automatic", color: "Blue", description: "Well-equipped Corolla with great value and comfort."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Corolla", trim: "SE", price: 24045, carType: "Sedan", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 169, transmission: "Automatic", color: "Red", description: "Sporty Corolla with enhanced styling and performance."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Corolla Hybrid", trim: "LE", price: 24800, carType: "Sedan", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 121, transmission: "Automatic", color: "Silver", description: "Efficient hybrid compact with outstanding gas mileage."),
        
        // 2024 Corolla
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Corolla", trim: "LE", price: 23400, carType: "Sedan", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 139, transmission: "Automatic", color: "Gray", description: "Reliable compact sedan perfect for daily commuting."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Corolla", trim: "SE", price: 24650, carType: "Sedan", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 169, transmission: "Automatic", color: "Black", description: "Sport-tuned Corolla with aggressive design."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Corolla Hybrid", trim: "LE", price: 25300, carType: "Sedan", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 121, transmission: "Automatic", color: "Blue", description: "Eco-friendly compact with impressive efficiency."),
        
        // 2023 RAV4
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "RAV4", trim: "LE", price: 28475, carType: "SUV", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 203, transmission: "Automatic", color: "White", description: "Popular compact SUV with ample cargo space."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "RAV4", trim: "XLE", price: 31705, carType: "SUV", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 203, transmission: "Automatic", color: "Silver", description: "Well-appointed RAV4 with comfort and convenience features."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "RAV4", trim: "Limited", price: 37130, carType: "SUV", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 203, transmission: "Automatic", color: "Black", description: "Premium RAV4 with luxury amenities and advanced tech."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "RAV4 Hybrid", trim: "LE", price: 32575, carType: "SUV", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 219, transmission: "Automatic", color: "Blue", description: "Efficient hybrid SUV perfect for families."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "RAV4 Prime", trim: "SE", price: 43090, carType: "SUV", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 302, transmission: "Automatic", color: "Red", description: "Plug-in hybrid with impressive performance and efficiency."),
        
        // 2024 RAV4
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "RAV4", trim: "LE", price: 29075, carType: "SUV", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 203, transmission: "Automatic", color: "Gray", description: "Versatile SUV with rugged capability and modern features."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "RAV4", trim: "XLE Premium", price: 34275, carType: "SUV", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 203, transmission: "Automatic", color: "White", description: "Upscale RAV4 with premium interior and tech upgrades."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "RAV4 Hybrid", trim: "XLE", price: 35225, carType: "SUV", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 219, transmission: "Automatic", color: "Silver", description: "Fuel-efficient SUV combining space with economy."),
        
        // 2023 Highlander
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Highlander", trim: "L", price: 36420, carType: "SUV", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 265, transmission: "Automatic", color: "White", description: "Three-row midsize SUV perfect for larger families."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Highlander", trim: "LE", price: 39120, carType: "SUV", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 265, transmission: "Automatic", color: "Black", description: "Comfortable family SUV with spacious interior."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Highlander", trim: "XLE", price: 42670, carType: "SUV", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 265, transmission: "Automatic", color: "Silver", description: "Well-equipped Highlander with premium comfort features."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Highlander Hybrid", trim: "LE", price: 42320, carType: "SUV", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 243, transmission: "Automatic", color: "Blue", description: "Fuel-efficient three-row SUV with hybrid technology."),
        
        // 2024 Highlander
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Highlander", trim: "LE", price: 40000, carType: "SUV", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 265, transmission: "Automatic", color: "Gray", description: "Spacious SUV ideal for growing families."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Highlander", trim: "XLE", price: 43640, carType: "SUV", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 265, transmission: "Automatic", color: "White", description: "Premium family SUV with advanced safety features."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Highlander Hybrid", trim: "Limited", price: 50195, carType: "SUV", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 243, transmission: "Automatic", color: "Black", description: "Luxurious hybrid SUV with exceptional comfort."),
        
        // 2023 Tacoma
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Tacoma", trim: "SR", price: 28600, carType: "Truck", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "2–4 seats", horsepower: 159, transmission: "Manual", color: "White", description: "Capable midsize truck built for work and adventure."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Tacoma", trim: "SR5", price: 31900, carType: "Truck", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "2–4 seats", horsepower: 278, transmission: "Automatic", color: "Gray", description: "Popular truck with excellent off-road capability."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Tacoma", trim: "TRD Sport", price: 38605, carType: "Truck", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "2–4 seats", horsepower: 278, transmission: "Automatic", color: "Black", description: "Sport-tuned Tacoma with enhanced performance features."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Tacoma", trim: "TRD Off-Road", price: 39250, carType: "Truck", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "2–4 seats", horsepower: 278, transmission: "Automatic", color: "Green", description: "Off-road ready truck with advanced 4WD system."),
        
        // 2024 Tacoma
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Tacoma", trim: "SR5", price: 32500, carType: "Truck", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "2–4 seats", horsepower: 278, transmission: "Automatic", color: "Silver", description: "Reliable midsize truck for work and play."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Tacoma", trim: "TRD Pro", price: 50420, carType: "Truck", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "2–4 seats", horsepower: 278, transmission: "Automatic", color: "Red", description: "Premium off-road truck with professional-grade features."),
        
        // 2023 Tundra
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Tundra", trim: "SR", price: 39965, carType: "Truck", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "4+ seats", horsepower: 389, transmission: "Automatic", color: "White", description: "Full-size truck with powerful towing capacity."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Tundra", trim: "SR5", price: 45565, carType: "Truck", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "4+ seats", horsepower: 389, transmission: "Automatic", color: "Black", description: "Versatile full-size truck for heavy-duty tasks."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Tundra", trim: "Limited", price: 54565, carType: "Truck", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "4+ seats", horsepower: 389, transmission: "Automatic", color: "Silver", description: "Premium truck combining luxury with capability."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Tundra Hybrid", trim: "Limited", price: 58765, carType: "Truck", fuelType: "Hybrid", mpg: "20–30", range: "200–300 mi", seating: "4+ seats", horsepower: 437, transmission: "Automatic", color: "Blue", description: "Powerful hybrid truck with improved fuel economy."),
        
        // 2024 Tundra
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Tundra", trim: "SR5", price: 46555, carType: "Truck", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "4+ seats", horsepower: 389, transmission: "Automatic", color: "Gray", description: "Capable full-size truck with modern amenities."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Tundra", trim: "Platinum", price: 61135, carType: "Truck", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "4+ seats", horsepower: 389, transmission: "Automatic", color: "White", description: "Luxurious truck with premium features and comfort."),
        
        // 2023 4Runner
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "4Runner", trim: "SR5", price: 41450, carType: "SUV", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "4+ seats", horsepower: 270, transmission: "Automatic", color: "White", description: "Rugged SUV built for off-road adventures."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "4Runner", trim: "TRD Off-Road", price: 44750, carType: "SUV", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "4+ seats", horsepower: 270, transmission: "Automatic", color: "Black", description: "Trail-ready SUV with enhanced off-road features."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "4Runner", trim: "Limited", price: 50490, carType: "SUV", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "4+ seats", horsepower: 270, transmission: "Automatic", color: "Silver", description: "Premium 4Runner with luxury appointments."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "4Runner", trim: "TRD Pro", price: 54080, carType: "SUV", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "4+ seats", horsepower: 270, transmission: "Automatic", color: "Green", description: "Ultimate off-road SUV with pro-grade equipment."),
        
        // 2024 4Runner
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "4Runner", trim: "SR5", price: 42300, carType: "SUV", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "4+ seats", horsepower: 270, transmission: "Automatic", color: "Gray", description: "Adventure-ready SUV with legendary reliability."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "4Runner", trim: "TRD Pro", price: 55275, carType: "SUV", fuelType: "Gasoline", mpg: "< 20", range: "200–300 mi", seating: "4+ seats", horsepower: 270, transmission: "Automatic", color: "Red", description: "Top-tier off-road SUV for serious adventurers."),
        
        // 2023 Prius
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Prius", trim: "LE", price: 27450, carType: "Hatchback", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 121, transmission: "Automatic", color: "White", description: "Iconic hybrid hatchback with exceptional fuel economy."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Prius", trim: "XLE", price: 32200, carType: "Hatchback", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 121, transmission: "Automatic", color: "Blue", description: "Well-equipped Prius with premium comfort features."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Prius Prime", trim: "SE", price: 32625, carType: "Hatchback", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 121, transmission: "Automatic", color: "Silver", description: "Plug-in hybrid with impressive electric-only range."),
        
        // 2024 Prius
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Prius", trim: "LE", price: 28545, carType: "Hatchback", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 194, transmission: "Automatic", color: "Red", description: "Redesigned Prius with sportier styling and more power."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Prius", trim: "XLE", price: 33095, carType: "Hatchback", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 194, transmission: "Automatic", color: "Black", description: "Premium Prius with advanced technology features."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Prius Prime", trim: "XSE", price: 39305, carType: "Hatchback", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 220, transmission: "Automatic", color: "White", description: "High-performance plug-in hybrid with sporty design."),
        
        // 2023 GR86
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "GR86", trim: "Base", price: 29395, carType: "Coupe", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "2–4 seats", horsepower: 228, transmission: "Manual", color: "Red", description: "Pure sports car with rear-wheel drive and manual transmission."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "GR86", trim: "Premium", price: 32495, carType: "Coupe", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "2–4 seats", horsepower: 228, transmission: "Automatic", color: "Blue", description: "Thrilling sports coupe with premium features."),
        
        // 2024 GR86
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "GR86", trim: "Base", price: 30295, carType: "Coupe", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "2–4 seats", horsepower: 228, transmission: "Manual", color: "Black", description: "Driver-focused sports car with excellent handling."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "GR86", trim: "Premium", price: 33395, carType: "Coupe", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "2–4 seats", horsepower: 228, transmission: "Automatic", color: "White", description: "Premium sports coupe for enthusiast drivers."),
        
        // 2023 Sienna
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Sienna", trim: "LE", price: 37365, carType: "Van", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 245, transmission: "Automatic", color: "Silver", description: "Family-friendly hybrid minivan with spacious interior."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Sienna", trim: "XLE", price: 44085, carType: "Van", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 245, transmission: "Automatic", color: "White", description: "Well-equipped minivan with premium comfort."),
        ToyotaVehicleData(year: 2023, make: "Toyota", model: "Sienna", trim: "Limited", price: 51935, carType: "Van", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 245, transmission: "Automatic", color: "Black", description: "Luxurious hybrid minivan with advanced features."),
        
        // 2024 Sienna
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Sienna", trim: "LE", price: 38090, carType: "Van", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 245, transmission: "Automatic", color: "Gray", description: "Versatile hybrid minivan perfect for families."),
        ToyotaVehicleData(year: 2024, make: "Toyota", model: "Sienna", trim: "Platinum", price: 54275, carType: "Van", fuelType: "Hybrid", mpg: "> 30", range: "> 300 mi", seating: "4+ seats", horsepower: 245, transmission: "Automatic", color: "White", description: "Top-tier minivan with luxury and convenience features.")
    ]
    
    // MARK: - Helper Functions
    
    func getRandomCars(count: Int) -> [Car] {
        let shuffled = vehicles.shuffled()
        let selected = Array(shuffled.prefix(count))
        return selected.map { convertToCar($0) }
    }
    
    func getFilteredCars(preferences: Preferences, likes: [Car], dislikes: [Car], count: Int) -> [Car] {
        var filtered = vehicles
        
        // Filter by selected car types
        if !preferences.selectedCarTypes.isEmpty {
            filtered = filtered.filter { preferences.selectedCarTypes.contains($0.carType) }
        }
        
        // Filter by selected fuel types
        if !preferences.selectedFuelTypes.isEmpty {
            filtered = filtered.filter { preferences.selectedFuelTypes.contains($0.fuelType) }
        }
        
        // Filter by MPG
        if !preferences.selectedMpgOptions.isEmpty {
            filtered = filtered.filter { preferences.selectedMpgOptions.contains($0.mpg) }
        }
        
        // Filter by range
        if !preferences.selectedRanges.isEmpty {
            filtered = filtered.filter { preferences.selectedRanges.contains($0.range) }
        }
        
        // Filter by seating
        if !preferences.selectedSeatings.isEmpty {
            filtered = filtered.filter { preferences.selectedSeatings.contains($0.seating) }
        }
        
        // Filter by price preferences
        if !preferences.selectedPriceOptions.isEmpty {
            filtered = filtered.filter { vehicle in
                for priceOption in preferences.selectedPriceOptions {
                    if priceOption == "Under $30,000" && vehicle.price < 30000 {
                        return true
                    } else if priceOption == "$30,000 - $50,000" && vehicle.price >= 30000 && vehicle.price <= 50000 {
                        return true
                    } else if priceOption == "$50,000+" && vehicle.price > 50000 {
                        return true
                    }
                }
                return false
            }
        }
        
        // Remove cars that were disliked
        let dislikedModels = Set(dislikes.map { $0.model })
        filtered = filtered.filter { !dislikedModels.contains($0.model) }
        
        // Prioritize similar cars to liked ones
        let likedModels = Set(likes.map { $0.model })
        let likedTypes = Set(likes.map { $0.carType })
        let likedFuelTypes = Set(likes.map { $0.fuelType })
        
        // Score each car based on similarity to likes
        let scored = filtered.map { vehicle -> (vehicle: ToyotaVehicleData, score: Int) in
            var score = 0
            if likedModels.contains(vehicle.model) { score += 3 }
            if likedTypes.contains(vehicle.carType) { score += 2 }
            if likedFuelTypes.contains(vehicle.fuelType) { score += 1 }
            
            // Bonus for matching zodiac element personality
            let elementScore = getElementScore(preferences: preferences, vehicle: vehicle)
            score += elementScore
            
            return (vehicle, score)
        }
        
        // Sort by score and shuffle within same scores for variety
        let sorted = scored.sorted { $0.score > $1.score }
        let selected = Array(sorted.prefix(count))
        
        return selected.map { convertToCar($0.vehicle, matchReason: generateMatchReason(preferences: preferences, likes: likes, vehicle: $0.vehicle)) }
    }
    
    private func getElementScore(preferences: Preferences, vehicle: ToyotaVehicleData) -> Int {
        let element = preferences.elementName
        
        switch element {
        case "Fire":
            // Fire signs like sporty, powerful vehicles
            if vehicle.carType == "Coupe" || vehicle.carType == "Truck" || vehicle.horsepower > 250 {
                return 2
            }
        case "Earth":
            // Earth signs prefer practical, reliable vehicles
            if vehicle.carType == "Sedan" || vehicle.fuelType == "Hybrid" {
                return 2
            }
        case "Air":
            // Air signs like modern, efficient vehicles
            if vehicle.fuelType == "Hybrid" || vehicle.fuelType == "Electric" || vehicle.year == 2024 {
                return 2
            }
        case "Water":
            // Water signs prefer comfortable, family-oriented vehicles
            if vehicle.carType == "SUV" || vehicle.carType == "Van" || vehicle.seating == "4+ seats" {
                return 2
            }
        default:
            break
        }
        
        return 0
    }
    
    private func generateMatchReason(preferences: Preferences, likes: [Car], vehicle: ToyotaVehicleData) -> String {
        var reasons: [String] = []
        
        // Check vibes
        if preferences.selectedVibes.contains("Sporty") && vehicle.horsepower > 200 {
            reasons.append("matches your sporty vibe with \(vehicle.horsepower) HP")
        }
        if preferences.selectedVibes.contains("Luxurious") && vehicle.price > 45000 {
            reasons.append("offers the luxury you desire")
        }
        if preferences.selectedVibes.contains("Adventurous") && (vehicle.carType == "Truck" || vehicle.carType == "SUV") {
            reasons.append("perfect for your adventurous lifestyle")
        }
        if preferences.selectedVibes.contains("Minimalist") && vehicle.fuelType == "Hybrid" {
            reasons.append("efficient and eco-friendly for your minimalist approach")
        }
        
        // Check element
        switch preferences.elementName {
        case "Fire":
            if vehicle.horsepower > 250 {
                reasons.append("powerful engine suits your fiery spirit")
            }
        case "Earth":
            if vehicle.fuelType == "Hybrid" {
                reasons.append("reliable hybrid matches your grounded nature")
            }
        case "Air":
            if vehicle.year == 2024 {
                reasons.append("latest model aligns with your forward-thinking mindset")
            }
        case "Water":
            if vehicle.seating == "4+ seats" {
                reasons.append("spacious interior fits your caring personality")
            }
        default:
            break
        }
        
        // Check similar to likes
        let likedTypes = Set(likes.map { $0.carType })
        if likedTypes.contains(vehicle.carType) {
            reasons.append("similar to other \(vehicle.carType.lowercased())s you liked")
        }
        
        if reasons.isEmpty {
            return "Great all-around choice that meets your preferences"
        }
        
        return reasons.prefix(2).joined(separator: " and ")
    }
    
    // Changed from private to internal for access from FinancingFeature
    func convertToCar(_ vehicle: ToyotaVehicleData, matchReason: String? = nil) -> Car {
        return Car(
            model: vehicle.model,
            year: vehicle.year,
            carType: vehicle.carType,
            fuelType: vehicle.fuelType,
            mpg: vehicle.mpg,
            range: vehicle.range,
            seating: vehicle.seating,
            price: vehicle.price,
            horsepower: vehicle.horsepower,
            transmission: vehicle.transmission,
            color: vehicle.color,
            description: vehicle.description,
            matchReason: matchReason,
            imageURL: nil
        )
    }
}
