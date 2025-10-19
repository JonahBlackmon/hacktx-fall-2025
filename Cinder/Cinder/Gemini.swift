// GeminiService.swift
// Add this as a new file to handle all Gemini API interactions

import Foundation
import SwiftUI
import Combine  // ← ADD THIS IMPORT

// MARK: - Configuration
struct GeminiConfig {
    static let apiKey = "AIzaSyBEIG9bkRZEcZA4RGGCt7qBKWE3p2mDeKk" // Replace with your actual key
    static let apiURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"
}

// MARK: - Preferences Model (moved from ContentView for accessibility)
struct Preferences: Codable {
    var birthday: Date
    var selectedVibes: [String]
    var selectedCategory: String?
    var selectedCarTypes: [String]
    var selectedFuelTypes: [String]
    var selectedMpgOptions: [String]
    var selectedRanges: [String]
    var selectedSeatings: [String]
    var selectedPriceOptions: [String]
    var selectedTab: Int
    
    // Derived zodiac/element fields
    var zodiacName: String
    var zodiacEmoji: String
    var zodiacDateRange: String
    var elementName: String
    var elementEmoji: String
    
    // NEW: Financial Information
    var annualIncome: String?
    var creditScore: String?
}

// MARK: - Enhanced Car Model
struct ToyotaCar: Identifiable, Hashable, Codable {
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

// MARK: - User Interaction Tracking
struct UserInteraction: Codable {
    let car: ToyotaCar
    let action: String // "like" or "dislike"
    let timestamp: Date
}

// MARK: - Gemini API Models
struct GeminiRequest: Codable {
    struct Content: Codable {
        struct Part: Codable {
            let text: String
        }
        let parts: [Part]
    }
    let contents: [Content]
}

struct GeminiResponse: Codable {
    struct Candidate: Codable {
        struct Content: Codable {
            struct Part: Codable {
                let text: String
            }
            let parts: [Part]
        }
        let content: Content
    }
    let candidates: [Candidate]
}

// MARK: - Gemini Service
@MainActor
class GeminiService: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - Database Methods (Primary - No API needed)
    
    func getInitialCarsFromDatabase() async -> [Car] {
        // Simulate network delay for realistic UX
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return ToyotaDatabase.shared.getRandomCars(count: 5)
    }
    
    func getPersonalizedCarsFromDatabase(
        preferences: Preferences,
        likes: [Car],
        dislikes: [Car]
    ) async -> [Car] {
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        return ToyotaDatabase.shared.getFilteredCars(
            preferences: preferences,
            likes: likes,
            dislikes: dislikes,
            count: 5
        )
    }
    
    // MARK: - API Methods (Backup - requires API key)
    func getInitialCars() async throws -> [ToyotaCar] {
        let prompt = """
        Generate 5 random Toyota car recommendations in JSON format.
        For each car, include these exact fields:
        - model (string): Toyota model name
        - year (integer): 2020-2025
        - carType (string): one of [Sedan, SUV, Truck, Coupe, Hatchback, Van]
        - fuelType (string): one of [Gasoline, Diesel, Hybrid, Electric, Hydrogen]
        - mpg (string): one of ["< 20", "20–30", "> 30"]
        - range (string): one of ["< 200 mi", "200–300 mi", "> 300 mi"]
        - seating (string): one of ["2 seats", "2–4 seats", "4+ seats"]
        - price (integer): price in dollars (20000-80000)
        - horsepower (integer): 100-400
        - transmission (string): "Automatic" or "Manual"
        - color (string): any common car color
        - description (string): brief 1-2 sentence description
        - imageURL (string or null): set to null
        - matchReason (string or null): set to null
        
        Return ONLY a valid JSON array with no markdown formatting or additional text.
        """
        
        return try await makeGeminiRequest(prompt: prompt)
    }
    
    // MARK: - 2. Get Personalized Recommendations
    func getPersonalizedRecommendations(
        preferences: Preferences,
        likes: [ToyotaCar],
        dislikes: [ToyotaCar]
    ) async throws -> [ToyotaCar] {
        let preferencesJSON = try encodeToJSON(preferences)
        let likesJSON = try encodeToJSON(likes)
        let dislikesJSON = try encodeToJSON(dislikes)
        
        let prompt = """
        Based on the user's profile preferences and their likes/dislikes, recommend 5 new Toyota cars.
        
        USER PROFILE PREFERENCES:
        \(preferencesJSON)
        
        CARS THEY LIKED:
        \(likesJSON)
        
        CARS THEY DISLIKED:
        \(dislikesJSON)
        
        ANALYSIS INSTRUCTIONS:
        1. Identify patterns in their likes vs dislikes
        2. Match their zodiac element personality traits to car characteristics
        3. Align with their selected vibes and preferences
        4. Avoid characteristics similar to disliked cars
        5. Consider their budget from price preferences
        
        Generate 5 Toyota car recommendations that match their taste.
        For each car, include these exact fields:
        - model (string): Toyota model name
        - year (integer): 2020-2025
        - carType (string): one of [Sedan, SUV, Truck, Coupe, Hatchback, Van]
        - fuelType (string): one of [Gasoline, Diesel, Hybrid, Electric, Hydrogen]
        - mpg (string): one of ["< 20", "20–30", "> 30"]
        - range (string): one of ["< 200 mi", "200–300 mi", "> 300 mi"]
        - seating (string): one of ["2 seats", "2–4 seats", "4+ seats"]
        - price (integer): price in dollars matching their budget
        - horsepower (integer): 100-400
        - transmission (string): "Automatic" or "Manual"
        - color (string): any common car color
        - description (string): brief 1-2 sentence description
        - imageURL (string or null): set to null
        - matchReason (string): explain in 1 sentence why this matches their preferences
        
        Return ONLY a valid JSON array with no markdown formatting or additional text.
        """
        
        return try await makeGeminiRequest(prompt: prompt)
    }
    
    // MARK: - Core API Request
    private func makeGeminiRequest(prompt: String) async throws -> [ToyotaCar] {
        isLoading = true
        defer { isLoading = false }
        
        print("\n" + String(repeating: "=", count: 80))
        print("🤖 GEMINI REQUEST")
        print(String(repeating: "=", count: 80))
        print("PROMPT SENT:")
        print(prompt)
        print(String(repeating: "-", count: 80))
        
        guard let url = URL(string: "\(GeminiConfig.apiURL)?key=\(GeminiConfig.apiKey)") else {
            throw GeminiError.invalidURL
        }
        
        let request = GeminiRequest(
            contents: [
                GeminiRequest.Content(
                    parts: [GeminiRequest.Content.Part(text: prompt)]
                )
            ]
        )
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GeminiError.invalidResponse
        }
        
        print("📡 HTTP Status Code: \(httpResponse.statusCode)")
        
        guard httpResponse.statusCode == 200 else {
            print("❌ API Error - Status: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Error Response: \(responseString)")
            }
            throw GeminiError.apiError(statusCode: httpResponse.statusCode)
        }
        
        let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
        
        guard let responseText = geminiResponse.candidates.first?.content.parts.first?.text else {
            throw GeminiError.noResponse
        }
        
        print("\n📥 RAW GEMINI RESPONSE:")
        print(responseText)
        print(String(repeating: "-", count: 80))
        
        // Extract JSON from response (handle markdown code blocks)
        let jsonString = extractJSON(from: responseText)
        
        print("\n📋 EXTRACTED JSON:")
        print(jsonString)
        print(String(repeating: "-", count: 80))
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            throw GeminiError.invalidJSON
        }
        
        // Try to decode and catch specific errors
        let decoder = JSONDecoder()
        do {
            let cars = try decoder.decode([ToyotaCar].self, from: jsonData)
            
            print("\n✅ PARSED \(cars.count) CARS:")
            for (index, car) in cars.enumerated() {
                print("\n[\(index + 1)] \(car.title)")
                print("   Type: \(car.carType) | Fuel: \(car.fuelType)")
                print("   Price: $\(car.price) | HP: \(car.horsepower)")
                print("   MPG: \(car.mpg) | Range: \(car.range) | Seats: \(car.seating)")
                if let matchReason = car.matchReason {
                    print("   Match: \(matchReason)")
                }
            }
            print(String(repeating: "=", count: 80) + "\n")
            
            return cars
        } catch {
            print("\n❌ JSON DECODING ERROR:")
            print(error)
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("Missing key: \(key.stringValue)")
                    print("Context: \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("Type mismatch for type: \(type)")
                    print("Context: \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("Value not found for type: \(type)")
                    print("Context: \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("Data corrupted: \(context.debugDescription)")
                @unknown default:
                    print("Unknown decoding error")
                }
            }
            throw GeminiError.invalidJSON
        }
    }
    
    // MARK: - Helper Methods
    private func extractJSON(from text: String) -> String {
        // Remove markdown code blocks if present
        let patterns = [
            "```json\\s*\\n([\\s\\S]*?)```",
            "```\\s*\\n([\\s\\S]*?)```"
        ]
        
        var cleanedText = text
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern),
               let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) {
                if let range = Range(match.range(at: 1), in: text) {
                    cleanedText = String(text[range])
                    break
                }
            }
        }
        
        // Trim whitespace
        cleanedText = cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Check if it starts with [ and extract the array
        if cleanedText.hasPrefix("[") {
            // Try to parse as JSON to check if it's valid
            if let jsonData = cleanedText.data(using: .utf8),
               let jsonObject = try? JSONSerialization.jsonObject(with: jsonData) {
                // Check if it's a nested array
                if let outerArray = jsonObject as? [Any],
                   let firstElement = outerArray.first,
                   let innerArray = firstElement as? [[String: Any]] {
                    // It's a nested array, extract the inner array
                    if let data = try? JSONSerialization.data(withJSONObject: innerArray),
                       let jsonString = String(data: data, encoding: .utf8) {
                        print("🔧 Fixed nested array structure")
                        return jsonString
                    }
                }
            }
            // If not nested or parsing failed, return as-is
            return cleanedText
        }
        
        // Try to find JSON array in the text
        if let regex = try? NSRegularExpression(pattern: "\\[([\\s\\S]*)\\]"),
           let match = regex.firstMatch(in: cleanedText, range: NSRange(cleanedText.startIndex..., in: cleanedText)) {
            if let range = Range(match.range, in: cleanedText) {
                return String(cleanedText[range])
            }
        }
        
        return cleanedText
    }
    
    private func encodeToJSON<T: Encodable>(_ value: T) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(value)
        return String(data: data, encoding: .utf8) ?? "{}"
    }
}

// MARK: - Error Handling
enum GeminiError: LocalizedError {
    case invalidURL
    case invalidResponse
    case apiError(statusCode: Int)
    case noResponse
    case invalidJSON
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .apiError(let code):
            return "API error: \(code)"
        case .noResponse:
            return "No response from Gemini"
        case .invalidJSON:
            return "Could not parse car data"
        }
    }
}

// MARK: - Image Fetching Service
@MainActor
class CarImageService: ObservableObject {
    private let supabaseURL = "https://vpnhpotapmshenlesdwc.supabase.co"
    private let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZwbmhwb3RhcG1zaGVubGVzZHdjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjA4MDc3NzMsImV4cCI6MjA3NjM4Mzc3M30.xH0NKtbcXLJAY-Lp1a_c2KXWG-wMMlJkA9UvW-eRbsw"
    
    func fetchImage(for car: Car) async -> String {
        // If car already has an imageURL, use it
        if let imageURL = car.imageURL, !imageURL.isEmpty {
            return imageURL
        }
        
        // Option 1: Try Supabase storage
        let supabaseImageURL = "\(supabaseURL)/storage/v1/object/public/car-images/\(car.year)-\(car.model.replacingOccurrences(of: " ", with: "-").lowercased()).jpg"
        
        if await checkImageExists(url: supabaseImageURL) {
            return supabaseImageURL
        }
        
        // Option 2: Fallback to placeholder with car model
        return "https://source.unsplash.com/800x600/?toyota,\(car.model.replacingOccurrences(of: " ", with: ","))"
    }
    
    private func checkImageExists(url: String) async -> Bool {
        guard let url = URL(string: url) else { return false }
        
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            return (response as? HTTPURLResponse)?.statusCode == 200
        } catch {
            return false
        }
    }
}

// MARK: - Updated ContentView Integration
/*
IMPORTANT: Remove the duplicate Preferences struct from ContentView.swift since it's now in this file.

Add these to your ContentView:

1. Add these @StateObject properties:
    @StateObject private var geminiService = GeminiService()
    @StateObject private var imageService = CarImageService()
    @StateObject private var interactionManager = InteractionManager()

2. Replace your cards array type:
    @State private var cards: [ToyotaCar] = []

3. Add loading state:
    @State private var isLoadingCars = false

4. Update onAppear in carsTab:
    .onAppear {
        interactionManager.loadFromUserDefaults()
        Task {
            if cards.isEmpty {
                await loadInitialCars()
            }
        }
    }

5. Add these methods to ContentView:

    private func loadInitialCars() async {
        isLoadingCars = true
        do {
            let newCars = try await geminiService.getInitialCars()
            cards = newCars
        } catch {
            print("Error loading initial cars: \(error.localizedDescription)")
            geminiService.errorMessage = error.localizedDescription
        }
        isLoadingCars = false
    }

    private func loadPersonalizedCars() async {
        isLoadingCars = true
        do {
            let prefs = currentPreferences()
            let newCars = try await geminiService.getPersonalizedRecommendations(
                preferences: prefs,
                likes: interactionManager.likes,
                dislikes: interactionManager.dislikes
            )
            cards = newCars
        } catch {
            print("Error loading personalized cars: \(error.localizedDescription)")
            geminiService.errorMessage = error.localizedDescription
        }
        isLoadingCars = false
    }

6. Update swipeCard to use interactionManager:
    private func swipeCard(_ direction: SwipeDirection) {
        withAnimation(.spring()) {
            dragOffset = CGSize(width: direction == .right ? 500 : -500, height: 0)
            pendingSwipe = direction
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation {
                if !cards.isEmpty {
                    let currentCar = cards.last!
                    
                    if direction == .right {
                        interactionManager.addLike(currentCar)
                    } else {
                        interactionManager.addDislike(currentCar)
                    }
                    
                    cards.removeLast()
                }
                
                if cards.isEmpty {
                    Task {
                        await loadPersonalizedCars()
                    }
                }
                
                dragOffset = .zero
                pendingSwipe = nil
            }
        }
    }

7. Update CardView to use ToyotaCar and fetch images:
    @StateObject private var imageService = CarImageService()
    @State private var imageURL: String = ""
    
    var body: some View {
        GeometryReader { geo in
            AsyncImage(url: URL(string: imageURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Color.blue
                @unknown default:
                    Color.blue
                }
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .overlay(
                VStack(alignment: .leading, spacing: 4) {
                    Text(car.title)
                        .font(.title).bold()
                    Text("$\(car.price)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.85))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.bottom, geo.safeAreaInsets.bottom + 215)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            )
            .shadow(radius: 5)
        }
        .task {
            imageURL = await imageService.fetchImage(for: car)
        }
        .ignoresSafeArea()
    }

8. Show loading indicator when fetching cars in carsTab:
    if isLoadingCars {
        ProgressView("Loading cars...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    } else {
        // existing cardStack and buttons code
    }
*/
