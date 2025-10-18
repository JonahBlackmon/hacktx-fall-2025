//
//  ContentView.swift
//  Cinder
//
//  Created by Parth Mehta on 10/18/25.
//

import SwiftUI

// Added model for richer card data
struct Car: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let carType: String
    let fuelType: String
    let mpg: String
    let range: String
    let seating: String
}

struct ContentView: View {
    // replaced simple Strings with Car model instances
    @State private var cards: [Car] = [
        Car(title: "Card 1", carType: "Sedan", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats"),
        Car(title: "Card 2", carType: "SUV", fuelType: "Hybrid", mpg: "20–30", range: "> 300 mi", seating: "4+ seats"),
        Car(title: "Card 3", carType: "Coupe", fuelType: "Gasoline", mpg: "< 20", range: "< 200 mi", seating: "2 seats"),
        Car(title: "Card 4", carType: "Electric", fuelType: "Electric", mpg: "> 30", range: "> 300 mi", seating: "2–4 seats"),
        Car(title: "Card 5", carType: "Hatchback", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats")
    ]
    @State private var dragOffset = CGSize.zero
    enum SwipeDirection { case left, right }
    @State private var pendingSwipe: SwipeDirection? = nil
    @State private var selectedTab = 0
    // liked now stores Cars
    @State private var liked: [Car] = []
    @State private var birthday = Date() // use current date by default to avoid epoch/timezone showing "Dec 31, 1969"
    @State private var selectedVibes: Set<String> = []
    @State private var vibesExpanded = false
    @State private var autoCloseTask: DispatchWorkItem? = nil
    @State private var selectedCategory: String? = nil
    // popup for card details
    @State private var selectedDetail: Car? = nil
    // when true the sheet shows a compact "mini" card preview (used from Likes)
    @State private var detailCompact: Bool = false
    // allow multiple selections for these option groups
    @State private var selectedCarTypes: Set<String> = []
    @State private var selectedFuelTypes: Set<String> = []
    @State private var selectedMpgOptions: Set<String> = []
    @State private var selectedRanges: Set<String> = []
    @State private var selectedSeatings: Set<String> = []
    // price multi-select (new)
    @State private var selectedPriceOptions: Set<String> = []
    private let mpgOptions = ["< 20", "20–30", "> 30"]
    private let rangeOptions = ["< 200 mi", "200–300 mi", "> 300 mi"]
    private let seatingOptions = ["2 seats", "2–4 seats", "4+ seats"]
    private let carTypes = ["Sedan", "SUV", "Coupe", "Hatchback", "Truck", "Van"]
    private let fuelTypes = ["Gasoline", "Diesel", "Hybrid", "Electric", "Hydrogen"]
    private let priceOptions = ["Under $30,000", "$30,000 - $50,000", "$50,000+"]
    // ordered presets for the "How would you describe yourself?" section
    private let categoryPresets: [(name: String, vibes: [String])] = [
        ("Adventurous", ["Adventurous", "Energetic", "Spirited"]),
        ("Classy",      ["Classy", "Chic", "Timeless", "Luxurious"]),
        ("Minimalist",  ["Minimalist", "Timeless", "Sleek"]),
        ("Sporty",      ["Sporty", "Energetic", "Playful"]),
        ("Chill",       ["Chill", "Playful", "Fun"]),
        ("Edgy",        ["Edgy", "Rebellious", "Bold"]),
        ("Trustworthy", ["Trustworthy", "Smart"]),
        ("Luxurious",   ["Luxurious", "Classy", "Bold"])
    ]
    private let vibes = [
        "Adventurous",
        "Confident",
        "Sporty",
        "Sleek",
        "Bold",
        "Playful",
        "Classy",
        "Rugged",
        "Trustworthy",
        "Edgy",
        "Fun",
        "Luxurious",
        "Minimalist",
        "Spirited",
        "Chic",
        "Chill",
        "Energetic",
        "Timeless",
        "Rebellious",
        "Smart"
    ]

    var body: some View {
        TabView(selection: $selectedTab) {
            carsTab
                .tabItem { Label("Cars", systemImage: "car.fill") }
                .tag(0)

            likesTab
                .tabItem { Label("Likes", systemImage: "heart.fill") }
                .tag(1)

            profileTab
                .tabItem { Label("Profile", systemImage: "person.circle.fill") }
                .tag(2)
        }
        .background(Color.clear) // simplified to reduce type-check complexity
        // Present card details sheet from the top-level so it can be opened from any tab (including Likes)
        .sheet(item: $selectedDetail) { car in
            CardDetailSheetView(car: car, compact: detailCompact)
        }
    }

    // MARK: - Extracted subviews to reduce type-checking complexity

    private var carsTab: some View {
        VStack {
            // Stack cards and floating buttons in the same ZStack so buttons hover over cards
            ZStack(alignment: .bottom) {
                cardStack

                // Floating buttons that hover above the card
                if !cards.isEmpty {
                    HStack(spacing: 36) {
                        Button(action: { swipeCard(.left) }) {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 64, height: 64)
                                .foregroundColor(.red)
                                .background(Circle().fill(.white).opacity(0.001)) // preserves hit area
                        }

                        // Info button in the middle to show details for the top card
                        Button(action: {
                            if let top = cards.last {
                                detailCompact = false // opened from Cars -> full-size sheet
                                selectedDetail = top
                            }
                        }) {
                            Image(systemName: "info.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 48, height: 48)
                                .foregroundColor(.primary)
                                .background(Circle().fill(.white).opacity(0.001))
                        }

                        Button(action: { swipeCard(.right) }) {
                            Image(systemName: "heart.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 64, height: 64)
                                .foregroundColor(.green)
                                .background(Circle().fill(.white).opacity(0.001))
                        }
                    }
                    // adjust this bottom padding to control how far above the tab bar the buttons sit
                    .padding(.bottom, 40)
                    .shadow(radius: 8)
                }
            }
        }
        // details sheet is presented at the top level (.sheet on the TabView)
    }

    @ViewBuilder
    private var likesTab: some View {
        ScrollView {
            if liked.isEmpty {
                Text("No likes yet")
                    .foregroundColor(.secondary)
                    .padding(.top, 40)
            } else {
                let columns = [GridItem(.flexible()), GridItem(.flexible())]
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(liked) { car in
                        LikedCardCell(car: car) {
                            withAnimation {
                                if let idx = liked.firstIndex(of: car) {
                                    liked.remove(at: idx)
                                }
                            }
                        }
                        .frame(height: 150)
                        // when tapping a liked card, show a compact (mini) details sheet — do NOT switch tabs
                        .onTapGesture {
                            detailCompact = true
                            selectedDetail = car
                        }
                    }
                }
                .padding()
            }
        }
    }

    @ViewBuilder
    private var profileTab: some View {
        ScrollView {
            VStack(spacing: 16) {
                profileHeader
                zodiacView
                elementView
                categoryPresetsView
                vibesView

                // simpler single-level references to each chips block
                carTypeChips
                fuelTypeChips
                mpgChips
                rangeChips
                seatingChips
                priceChips

                Spacer()
            }
            .padding(.top, 24)
        }
    }

    // -- small wrappers to reduce type-check complexity --
    private var carTypeChips: some View {
        optionChips(title: "Car type", items: carTypes, selected: $selectedCarTypes)
    }

    private var fuelTypeChips: some View {
        optionChips(title: "Fuel type", items: fuelTypes, selected: $selectedFuelTypes)
    }

    private var mpgChips: some View {
        optionChips(title: "MPG", items: mpgOptions, selected: $selectedMpgOptions)
    }

    private var rangeChips: some View {
        optionChips(title: "Range", items: rangeOptions, selected: $selectedRanges)
    }

    private var seatingChips: some View {
        optionChips(title: "Seating", items: seatingOptions, selected: $selectedSeatings)
    }

    private var priceChips: some View {
        optionChips(title: "Price", items: priceOptions, selected: $selectedPriceOptions)
    }

    // --- small extracted subviews to help the compiler ---

    private var profileHeader: some View {
        Text("Profile")
            .font(.title2).bold()
            .padding(.horizontal)
    }

    private var zodiacView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Zodiac Sign")
                .font(.headline)
                .padding(.horizontal)

            HStack(spacing: 12) {
                Text(zodiacSign(for: birthday).emoji)
                    .font(.system(size: 48))

                VStack(alignment: .leading, spacing: 4) {
                    Text(zodiacSign(for: birthday).name)
                        .font(.title3).bold()
                    Text(zodiacSign(for: birthday).dateRange)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Put the compact date picker inside the HStack so it sits neatly on the right
                DatePicker("", selection: $birthday, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground)))
            .padding(.horizontal)
        }
    }

    // Celestial bodies replaced by a single "Element" display (Fire / Earth / Air / Water)
    private var elementView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Element")
                .font(.headline)
                .padding(.horizontal)

            HStack(spacing: 12) {
                let el = element(for: birthday)
                Text(el.emoji)
                    .font(.system(size: 48))

                VStack(alignment: .leading, spacing: 4) {
                    Text(el.name)
                        .font(.title3).bold()
                }

                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground)))
            .padding(.horizontal)
        }
    }

    private var categoryPresetsView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("How would you describe yourself?")
                .font(.headline)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categoryPresets.indices, id: \.self) { idx in
                        let cat = categoryPresets[idx]
                        categoryButton(for: cat)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }

    private func categoryButton(for cat: (name: String, vibes: [String])) -> some View {
        let isSelected = selectedCategory == cat.name
        return Button(action: {
            if isSelected {
                selectedCategory = nil
                selectedVibes.removeAll()
                autoCloseTask?.cancel()
                autoCloseTask = nil
            } else {
                selectedCategory = cat.name
                selectedVibes = Set(cat.vibes)
                withAnimation { vibesExpanded = true }

                autoCloseTask?.cancel()
                let task = DispatchWorkItem {
                    DispatchQueue.main.async {
                        withAnimation { vibesExpanded = false }
                        autoCloseTask = nil
                    }
                }
                autoCloseTask = task
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: task)
            }
        }) {
            Text(cat.name)
                .font(.subheadline).bold()
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(isSelected ? Color.blue : Color(UIColor.secondarySystemBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private var vibesView: some View {
        DisclosureGroup(isExpanded: $vibesExpanded) {
            let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                ForEach(vibes.indices, id: \.self) { idx in
                    let vibe = vibes[idx]
                    vibeButton(for: vibe)
                }
            }
            .padding(.vertical, 8)
        } label: {
            HStack {
                Text("Vibes")
                    .font(.headline)
                Spacer()
                Image(systemName: vibesExpanded ? "chevron.up" : "chevron.down")
                    .foregroundColor(.secondary)
            }
            .contentShape(Rectangle())
        }
        .animation(.easeInOut, value: vibesExpanded)
        .padding(.horizontal)
        .padding(.vertical, 4)
        .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground)))
        .padding(.horizontal)
    }

    private func vibeButton(for vibe: String) -> some View {
        let selected = selectedVibes.contains(vibe)
        return Button(action: {
            selectedCategory = nil
            if selected {
                selectedVibes.remove(vibe)
            } else {
                selectedVibes.insert(vibe)
            }
        }) {
            HStack(spacing: 8) {
                Text(vibe)
                    .font(.subheadline).bold()
                if selected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 14))
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(selected ? Color.blue : Color(UIColor.secondarySystemBackground))
            .foregroundColor(selected ? .white : .primary)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

    private func optionChips(title: String, items: [String], selected: Binding<Set<String>>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(items.indices, id: \.self) { idx in
                        let item = items[idx]
                        let isSelected = selected.wrappedValue.contains(item)
                        Button(action: {
                            if isSelected {
                                selected.wrappedValue.remove(item)
                            } else {
                                selected.wrappedValue.insert(item)
                            }
                        }) {
                            Text(item)
                                .font(.subheadline).bold()
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                                .background(isSelected ? Color.blue : Color(UIColor.secondarySystemBackground))
                                .foregroundColor(isSelected ? .white : .primary)
                                .clipShape(Capsule())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.horizontal)
    }

    // simplified background to avoid compiler type-check explosion
    private var backgroundView: some View {
        Color.clear
    }

    private var cardStack: some View {
        ZStack {
            ForEach(cards) { card in
                cardView(for: card)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.spring(), value: cards.count)
        .ignoresSafeArea(edges: .top)
    }

    @ViewBuilder
    private func cardView(for card: Car) -> some View {
        CardView(car: card)
            .offset(card.id == cards.last?.id ? dragOffset : .zero)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if pendingSwipe == nil && card.id == cards.last?.id {
                            dragOffset = value.translation
                        }
                    }
                    .onEnded { value in
                        if pendingSwipe == nil && card.id == cards.last?.id {
                            if value.translation.width > 100 {
                                swipeCard(.right)
                            } else if value.translation.width < -100 {
                                swipeCard(.left)
                            } else {
                                withAnimation { dragOffset = .zero }
                            }
                        }
                    }
            )
    }

    private func swipeCard(_ direction: SwipeDirection) {
        withAnimation(.spring()) {
            dragOffset = CGSize(width: direction == .right ? 500 : -500, height: 0)
            pendingSwipe = direction
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation {
                if !cards.isEmpty {
                    if direction == .right, let last = cards.last {
                        liked.append(last)
                    }
                    cards.removeLast()
                }
                if cards.isEmpty {
                    // repopulate sample cars (can be replaced by real data source)
                    cards = [
                        Car(title: "Card 1", carType: "Sedan", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats"),
                        Car(title: "Card 2", carType: "SUV", fuelType: "Hybrid", mpg: "20–30", range: "> 300 mi", seating: "4+ seats"),
                        Car(title: "Card 3", carType: "Coupe", fuelType: "Gasoline", mpg: "< 20", range: "< 200 mi", seating: "2 seats"),
                        Car(title: "Card 4", carType: "Electric", fuelType: "Electric", mpg: "> 30", range: "> 300 mi", seating: "2–4 seats"),
                        Car(title: "Card 5", carType: "Hatchback", fuelType: "Gasoline", mpg: "20–30", range: "200–300 mi", seating: "4+ seats")
                    ]
                }
                dragOffset = .zero
                pendingSwipe = nil
            }
        }
    }
}

struct CardView: View {
    // now takes Car model
    let car: Car
    var body: some View {
        GeometryReader { geo in
            RoundedRectangle(cornerRadius: 25)
                .fill(.blue)
                .frame(width: geo.size.width, height: geo.size.height)
                .overlay(
                    // Title + price placed in the bottom-left, raised above safe area/buttons
                    VStack(alignment: .leading, spacing: 4) {
                        Text(car.title)
                            .font(.title).bold()
                        Text(priceString(from: car.title))
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.85))
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    // account for the device safe area + extra spacing so text doesn't sit too low
                    .padding(.bottom, geo.safeAreaInsets.bottom + 215)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                )
                .shadow(radius: 5)
        }
        .ignoresSafeArea()
    }

    // derive a price from digits in the title, fallback to a default
    private func priceString(from title: String) -> String {
        let digits = title.compactMap { $0.isNumber ? String($0) : nil }.joined()
        if let n = Int(digits) {
            let val = 10_000 * n
            let fmt = NumberFormatter()
            fmt.numberStyle = .currency
            fmt.maximumFractionDigits = 0
            return fmt.string(from: NSNumber(value: val)) ?? "$\(val)"
        }
        return "$19,999"
    }
}

// Small cell for the Likes grid
struct LikedCardCell: View {
    // now takes Car
    let car: Car
    var onRemove: (() -> Void)? = nil

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.blue)
                .shadow(radius: 3)

            Text(car.title)
                .foregroundColor(.white)
                .bold()
        }
        .overlay(alignment: .topTrailing) {
            // small minus button in the top-right corner
            Button(action: {
                onRemove?()
            }) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .background(Circle().fill(Color.red).frame(width: 28, height: 28))
            }
            .buttonStyle(.plain)
            .padding(8)
        }
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// New: sheet content showing car details with explicit close button.
// Supports a compact mode used when opening from Likes (shows a mini card preview),
// while keeping the "additional info" Form layout identical to the car section.
private struct CardDetailSheetView: View {
    let car: Car
    let compact: Bool
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text(car.title)
                    .font(.title2).bold()
                Spacer()
                // explicit close button in the top-right
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal)
            .padding(.top)

            if compact {
                // mini preview that resembles the card shown in the Cars tab (keeps Cars section unchanged)
                MiniCardPreview(car: car)
                    .frame(height: 140)
                    .padding(.horizontal)
            } else {
                // optional fuller visual could go here, but we intentionally keep the Car section unchanged
                EmptyView()
            }

            // Keep the additional info layout unchanged
            Form {
                Section(header: Text("Specifications")) {
                    HStack { Text("Car type"); Spacer(); Text(car.carType).foregroundColor(.secondary) }
                    HStack { Text("Fuel type"); Spacer(); Text(car.fuelType).foregroundColor(.secondary) }
                    HStack { Text("MPG"); Spacer(); Text(car.mpg).foregroundColor(.secondary) }
                    HStack { Text("Range"); Spacer(); Text(car.range).foregroundColor(.secondary) }
                    HStack { Text("Seating"); Spacer(); Text(car.seating).foregroundColor(.secondary) }
                }
            }
        }
        .presentationDetents([.medium, .large])
    }
}

// A compact preview used inside the compact/detail sheet for Likes.
private struct MiniCardPreview: View {
    let car: Car
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.blue)
                .shadow(radius: 3)

            VStack(alignment: .leading, spacing: 6) {
                Text(car.title)
                    .font(.headline).bold()
                    .foregroundColor(.white)
                Text(priceString(from: car.title))
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func priceString(from title: String) -> String {
        let digits = title.compactMap { $0.isNumber ? String($0) : nil }.joined()
        if let n = Int(digits) {
            let val = 10_000 * n
            let fmt = NumberFormatter()
            fmt.numberStyle = .currency
            fmt.maximumFractionDigits = 0
            return fmt.string(from: NSNumber(value: val)) ?? "$\(val)"
        }
        return "$19,999"
    }
}

#Preview {
    ContentView()
}

// Returns name, emoji and human-readable date range for the zodiac sign
private func zodiacSign(for date: Date) -> (name: String, emoji: String, dateRange: String) {
    let comps = Calendar.current.dateComponents([.month, .day], from: date)
    guard let m = comps.month, let d = comps.day else { return ("Unknown", "❓", "") }
    switch (m, d) {
    case (3, 21...31), (4, 1...19):   return ("Aries", "♈️", "Mar 21 – Apr 19")
    case (4, 20...30), (5, 1...20):   return ("Taurus", "♉️", "Apr 20 – May 20")
    case (5, 21...31), (6, 1...20):   return ("Gemini", "♊️", "May 21 – Jun 20")
    case (6, 21...30), (7, 1...22):   return ("Cancer", "♋️", "Jun 21 – Jul 22")
    case (7, 23...31), (8, 1...22):   return ("Leo", "♌️", "Jul 23 – Aug 22")
    case (8, 23...31), (9, 1...22):   return ("Virgo", "♍️", "Aug 23 – Sep 22")
    case (9, 23...30), (10, 1...22):  return ("Libra", "♎️", "Sep 23 – Oct 22")
    case (10, 23...31), (11, 1...21): return ("Scorpio", "♏️", "Oct 23 – Nov 21")
    case (11, 22...30), (12, 1...21): return ("Sagittarius", "♐️", "Nov 22 – Dec 21")
    case (12, 22...31), (1, 1...19):  return ("Capricorn", "♑️", "Dec 22 – Jan 19")
    case (1, 20...31), (2, 1...18):   return ("Aquarius", "♒️", "Jan 20 – Feb 18")
    case (2, 19...29), (3, 1...20):   return ("Pisces", "♓️", "Feb 19 – Mar 20")
    default:                          return ("Unknown", "❓", "")
    }
}

// Move heavy string arrays to file-level constants to avoid type-check timeouts
private let zodiacOrderList: [String] = [
    "Aries","Taurus","Gemini","Cancer","Leo","Virgo",
    "Libra","Scorpio","Sagittarius","Capricorn","Aquarius","Pisces"
]

private let zodiacEmojisList: [String] = [
    "♈️","♉️","♊️","♋️","♌️","♍️","♎️","♏️","♐️","♑️","♒️","♓️"
]

// Returns the elemental association for the given date's zodiac sign
private func element(for date: Date) -> (name: String, emoji: String) {
    let sign = zodiacSign(for: date).name
    let fire = Set(["Aries", "Leo", "Sagittarius"])
    let earth = Set(["Taurus", "Virgo", "Capricorn"])
    let air = Set(["Gemini", "Libra", "Aquarius"])
    let water = Set(["Cancer", "Scorpio", "Pisces"])

    if fire.contains(sign) { return ("Fire", "🔥") }
    if earth.contains(sign) { return ("Earth", "🌍") }
    if air.contains(sign)  { return ("Air", "🌬️") }
    if water.contains(sign) { return ("Water", "💧") }
    return ("Unknown", "❓")
}
