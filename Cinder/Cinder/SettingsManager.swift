//
//  SettingsManager.swift
//  Cinder
//
//  Created by Jonah Blackmon on 10/18/25.
//

import SwiftUI
import Combine

struct Keys {
    static let PrimaryColor = "PrimaryColor"
    static let AccentColor = "AccentColor"
    static let TextColor = "TextColor"
    static let DarkMode = "DarkMode"
    static let likedCars = "likedCars"
    static let dislikedCars = "dislikedCars"
    static let birthday = "birthday"
    static let selectedVibes = "selectedVibes"
    static let selectedCategory = "selectedCategory"
    static let selectedCarTypes = "selectedCarTypes"
    static let selectedFuelTypes = "selectedFuelTypes"
    static let selectedMpgOptions = "selectedMpgOptions"
    static let selectedRanges = "selectedRanges"
    static let selectedSeatings = "selectedSeatings"
    static let selectedPriceOptions = "selectedPriceOptions"
    static let selectedIncome = "selectedIncome"
    static let selectedCreditScore = "selectedCreditScore"
}

let Colors: [String: Color] = [
    "darkRed": Color.darkRed,
    "beige": Color.beige,
    "toyotaRed": Color.toyotaRed,
    "coffee": Color.coffee,
    "darkBlue": Color.darkBlue,
    "offWhite": Color.offWhite
]

func colorFromString(colorString: String) -> Color {
    return Colors[colorString]!
}

// Data structures for profile
struct ZodiacSign {
    let name: String
    let emoji: String
    let dateRange: String
}

struct Element {
    let name: String
    let emoji: String
}

struct CategoryPreset: Identifiable {
    let id = UUID()
    let name: String
    let vibes: [String]
}

// Manager in charge of data related to UserDefaults and user preferences
class SettingsManager: ObservableObject {
    
    let defaults = UserDefaults.standard
    
    // Theme colors
    @Published var primaryColorString: String = "darkBlue"
    @Published var textColorString: String = "offWhite"
    @Published var accentColorString: String = "beige"
    @Published var lighterAccentString: String = "toyotaRed"
    @Published var darkerAccentColorString: String = "coffee"
    @Published var leftHanded: Bool = false
    @Published var darkMode: Bool
    
    // Car preferences
    @Published var likedCars: [String: Car] = [:] {
        didSet { saveLikedCars() }
    }
    @Published var dislikedCars: [String: Car] = [:] {
        didSet { saveDislikedCars() }
    }
    
    // Profile data
    @Published var birthday: Date = Date() {
        didSet { savePreference(birthday, forKey: Keys.birthday) }
    }
    @Published var selectedVibes: Set<String> = [] {
        didSet { saveSetPreference(selectedVibes, forKey: Keys.selectedVibes) }
    }
    @Published var selectedCategory: String? = nil {
        didSet { saveOptionalPreference(selectedCategory, forKey: Keys.selectedCategory) }
    }
    @Published var selectedCarTypes: Set<String> = [] {
        didSet { saveSetPreference(selectedCarTypes, forKey: Keys.selectedCarTypes) }
    }
    @Published var selectedFuelTypes: Set<String> = [] {
        didSet { saveSetPreference(selectedFuelTypes, forKey: Keys.selectedFuelTypes) }
    }
    @Published var selectedMpgOptions: Set<String> = [] {
        didSet { saveSetPreference(selectedMpgOptions, forKey: Keys.selectedMpgOptions) }
    }
    @Published var selectedRanges: Set<String> = [] {
        didSet { saveSetPreference(selectedRanges, forKey: Keys.selectedRanges) }
    }
    @Published var selectedSeatings: Set<String> = [] {
        didSet { saveSetPreference(selectedSeatings, forKey: Keys.selectedSeatings) }
    }
    @Published var selectedPriceOptions: Set<String> = [] {
        didSet { saveSetPreference(selectedPriceOptions, forKey: Keys.selectedPriceOptions) }
    }
    
    // Financial profile
    @Published var selectedIncome: String? = nil {
        didSet { saveOptionalPreference(selectedIncome, forKey: Keys.selectedIncome) }
    }
    @Published var selectedCreditScore: String? = nil {
        didSet { saveOptionalPreference(selectedCreditScore, forKey: Keys.selectedCreditScore) }
    }
    
    // Constant data
    let categoryPresets: [CategoryPreset] = [
        CategoryPreset(name: "Adventurous", vibes: ["Adventurous", "Energetic", "Spirited"]),
        CategoryPreset(name: "Classy", vibes: ["Classy", "Chic", "Timeless", "Luxurious"]),
        CategoryPreset(name: "Minimalist", vibes: ["Minimalist", "Timeless", "Sleek"]),
        CategoryPreset(name: "Sporty", vibes: ["Sporty", "Energetic", "Playful"]),
        CategoryPreset(name: "Chill", vibes: ["Chill", "Playful", "Fun"]),
        CategoryPreset(name: "Edgy", vibes: ["Edgy", "Rebellious", "Bold"]),
        CategoryPreset(name: "Trustworthy", vibes: ["Trustworthy", "Smart"]),
        CategoryPreset(name: "Luxurious", vibes: ["Luxurious", "Classy", "Bold"])
    ]
    
    let vibes = [
        "Adventurous", "Confident", "Sporty", "Sleek", "Bold", "Playful",
        "Classy", "Rugged", "Trustworthy", "Edgy", "Fun", "Luxurious",
        "Minimalist", "Spirited", "Chic", "Chill", "Energetic", "Timeless",
        "Rebellious", "Smart"
    ]
    
    let carTypes = ["Sedan", "SUV", "Coupe", "Hatchback", "Truck", "Van"]
    let fuelTypes = ["Gasoline", "Diesel", "Hybrid", "Electric", "Hydrogen"]
    let mpgOptions = ["< 20", "20–30", "> 30"]
    let rangeOptions = ["< 200 mi", "200–300 mi", "> 300 mi"]
    let seatingOptions = ["2 seats", "2–4 seats", "4+ seats"]
    let priceOptions = ["Under $30,000", "$30,000 - $50,000", "$50,000+"]
    
    let incomeRanges = [
        "Under $30,000",
        "$30,000 - $50,000",
        "$50,000 - $75,000",
        "$75,000 - $100,000",
        "$100,000+"
    ]
    
    let creditScoreRanges = [
        "750+",
        "700-749",
        "650-699",
        "600-649",
        "Below 600"
    ]
    
    // Computed properties
    var zodiacSign: ZodiacSign {
        return calculateZodiacSign(for: birthday)
    }
    
    var element: Element {
        return calculateElement(for: birthday)
    }
    
    var primaryColor: Color {
        return colorFromString(colorString: primaryColorString)
    }
    
    var accentColor: Color {
        return colorFromString(colorString: accentColorString)
    }
    
    var textColor: Color {
        return colorFromString(colorString: textColorString)
    }
    
    var lighterAccent: Color {
        return colorFromString(colorString: lighterAccentString)
    }
    
    var darkerAccent: Color {
        return colorFromString(colorString: darkerAccentColorString)
    }
    
    init() {
        self.darkMode = true
        
        // Load liked and disliked cars
        if let data = defaults.data(forKey: Keys.likedCars) {
            do {
                likedCars = try JSONDecoder().decode([String: Car].self, from: data)
            } catch {
                print("Error decoding liked cars: \(error)")
            }
        }
        
        if let data = defaults.data(forKey: Keys.dislikedCars) {
            do {
                dislikedCars = try JSONDecoder().decode([String: Car].self, from: data)
            } catch {
                print("Error decoding disliked cars: \(error)")
            }
        }
        
        // Load profile preferences
        loadPreferences()
    }
    
    // MARK: - Initialization
    
    func initializeAfterOnboarding() {
        setThemeColors()
    }
    
    func setThemeColors() {
        primaryColorString = darkMode ? "softBlack" : "offWhite"
        textColorString = darkMode ? "offWhite" : "softBlack"
    }
    
    // MARK: - Theme Management
    
    func toggleDarkMode() {
        defaults.set(darkMode, forKey: Keys.DarkMode)
        setThemeColors()
    }
    
    func updateThemeColors(primaryColor: String, textColor: String) {
        defaults.set(primaryColor, forKey: Keys.PrimaryColor)
        defaults.set(textColor, forKey: Keys.TextColor)
    }
    
    func updateCollegeColors(accentColor: String, lighterAccentColor: String) {
        defaults.set(lighterAccentColor, forKey: Keys.PrimaryColor)
        defaults.set(accentColor, forKey: Keys.AccentColor)
    }
    
    // MARK: - Car Management
    
    func writeLike(_ car: Car, ref: String) {
        likedCars[ref] = car
    }
    
    func removeLike(ref: String) {
        likedCars.removeValue(forKey: ref)
    }
    
    func writeDislike(_ car: Car, ref: String) {
        dislikedCars[ref] = car
    }
    
    func removeDislike(ref: String) {
        dislikedCars.removeValue(forKey: ref)
    }
    
    private func saveLikedCars() {
        do {
            let data = try JSONEncoder().encode(likedCars)
            defaults.set(data, forKey: Keys.likedCars)
        } catch {
            print("Error saving liked cars: \(error)")
        }
    }
    
    private func saveDislikedCars() {
        do {
            let data = try JSONEncoder().encode(dislikedCars)
            defaults.set(data, forKey: Keys.dislikedCars)
        } catch {
            print("Error saving disliked cars: \(error)")
        }
    }
    
    // MARK: - Preference Persistence
    
    private func loadPreferences() {
        // Load birthday
        if let birthdayData = defaults.object(forKey: Keys.birthday) as? Date {
            birthday = birthdayData
        }
        
        // Load selected vibes
        if let vibesArray = defaults.object(forKey: Keys.selectedVibes) as? [String] {
            selectedVibes = Set(vibesArray)
        }
        
        // Load selected category
        selectedCategory = defaults.string(forKey: Keys.selectedCategory)
        
        // Load car type preferences
        if let carTypesArray = defaults.object(forKey: Keys.selectedCarTypes) as? [String] {
            selectedCarTypes = Set(carTypesArray)
        }
        
        if let fuelTypesArray = defaults.object(forKey: Keys.selectedFuelTypes) as? [String] {
            selectedFuelTypes = Set(fuelTypesArray)
        }
        
        if let mpgArray = defaults.object(forKey: Keys.selectedMpgOptions) as? [String] {
            selectedMpgOptions = Set(mpgArray)
        }
        
        if let rangesArray = defaults.object(forKey: Keys.selectedRanges) as? [String] {
            selectedRanges = Set(rangesArray)
        }
        
        if let seatingsArray = defaults.object(forKey: Keys.selectedSeatings) as? [String] {
            selectedSeatings = Set(seatingsArray)
        }
        
        if let priceArray = defaults.object(forKey: Keys.selectedPriceOptions) as? [String] {
            selectedPriceOptions = Set(priceArray)
        }
        
        // Load financial profile
        selectedIncome = defaults.string(forKey: Keys.selectedIncome)
        selectedCreditScore = defaults.string(forKey: Keys.selectedCreditScore)
    }
    
    private func savePreference<T>(_ value: T, forKey key: String) {
        defaults.set(value, forKey: key)
    }
    
    private func saveOptionalPreference(_ value: String?, forKey key: String) {
        if let value = value {
            defaults.set(value, forKey: key)
        } else {
            defaults.removeObject(forKey: key)
        }
    }
    
    private func saveSetPreference(_ set: Set<String>, forKey key: String) {
        defaults.set(Array(set), forKey: key)
    }
    
    // MARK: - Zodiac & Element Calculations
    
    private func calculateZodiacSign(for date: Date) -> ZodiacSign {
        let comps = Calendar.current.dateComponents([.month, .day], from: date)
        guard let m = comps.month, let d = comps.day else {
            return ZodiacSign(name: "Unknown", emoji: "❓", dateRange: "")
        }
        
        switch (m, d) {
        case (3, 21...31), (4, 1...19):
            return ZodiacSign(name: "Aries", emoji: "♈️", dateRange: "Mar 21 – Apr 19")
        case (4, 20...30), (5, 1...20):
            return ZodiacSign(name: "Taurus", emoji: "♉️", dateRange: "Apr 20 – May 20")
        case (5, 21...31), (6, 1...20):
            return ZodiacSign(name: "Gemini", emoji: "♊️", dateRange: "May 21 – Jun 20")
        case (6, 21...30), (7, 1...22):
            return ZodiacSign(name: "Cancer", emoji: "♋️", dateRange: "Jun 21 – Jul 22")
        case (7, 23...31), (8, 1...22):
            return ZodiacSign(name: "Leo", emoji: "♌️", dateRange: "Jul 23 – Aug 22")
        case (8, 23...31), (9, 1...22):
            return ZodiacSign(name: "Virgo", emoji: "♍️", dateRange: "Aug 23 – Sep 22")
        case (9, 23...30), (10, 1...22):
            return ZodiacSign(name: "Libra", emoji: "♎️", dateRange: "Sep 23 – Oct 22")
        case (10, 23...31), (11, 1...21):
            return ZodiacSign(name: "Scorpio", emoji: "♏️", dateRange: "Oct 23 – Nov 21")
        case (11, 22...30), (12, 1...21):
            return ZodiacSign(name: "Sagittarius", emoji: "♐️", dateRange: "Nov 22 – Dec 21")
        case (12, 22...31), (1, 1...19):
            return ZodiacSign(name: "Capricorn", emoji: "♑️", dateRange: "Dec 22 – Jan 19")
        case (1, 20...31), (2, 1...18):
            return ZodiacSign(name: "Aquarius", emoji: "♒️", dateRange: "Jan 20 – Feb 18")
        case (2, 19...29), (3, 1...20):
            return ZodiacSign(name: "Pisces", emoji: "♓️", dateRange: "Feb 19 – Mar 20")
        default:
            return ZodiacSign(name: "Unknown", emoji: "❓", dateRange: "")
        }
    }
    
    private func calculateElement(for date: Date) -> Element {
        let sign = calculateZodiacSign(for: date).name
        let fire = Set(["Aries", "Leo", "Sagittarius"])
        let earth = Set(["Taurus", "Virgo", "Capricorn"])
        let air = Set(["Gemini", "Libra", "Aquarius"])
        let water = Set(["Cancer", "Scorpio", "Pisces"])
        
        if fire.contains(sign) { return Element(name: "Fire", emoji: "🔥") }
        if earth.contains(sign) { return Element(name: "Earth", emoji: "🌍") }
        if air.contains(sign) { return Element(name: "Air", emoji: "🌬️") }
        if water.contains(sign) { return Element(name: "Water", emoji: "💧") }
        
        return Element(name: "Unknown", emoji: "❓")
    }
    
    // MARK: - Preferences Export
    
    func exportPreferencesJSON() -> String? {
        let preferences: [String: Any] = [
            "birthday": ISO8601DateFormatter().string(from: birthday),
            "selectedVibes": Array(selectedVibes),
            "selectedCategory": selectedCategory ?? "",
            "selectedCarTypes": Array(selectedCarTypes),
            "selectedFuelTypes": Array(selectedFuelTypes),
            "selectedMpgOptions": Array(selectedMpgOptions),
            "selectedRanges": Array(selectedRanges),
            "selectedSeatings": Array(selectedSeatings),
            "selectedPriceOptions": Array(selectedPriceOptions),
            "selectedIncome": selectedIncome ?? "",
            "selectedCreditScore": selectedCreditScore ?? "",
            "zodiacSign": zodiacSign.name,
            "element": element.name
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: preferences, options: .prettyPrinted)
            return String(data: jsonData, encoding: .utf8)
        } catch {
            print("Error exporting preferences: \(error)")
            return nil
        }
    }
}
