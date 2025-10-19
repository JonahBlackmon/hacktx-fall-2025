////
////  ContentView.swift
////  Cinder
////
////  Updated with Gemini Integration + Financing Feature
////
//
//import SwiftUI
//
//struct ContentView: View {
//    // GEMINI SERVICES
//    @StateObject private var geminiService = GeminiService()
//    @StateObject private var imageService = CarImageService()
//    @StateObject private var interactionManager = InteractionManager()
//    
//    // Use ToyotaCar instead of Car
//    @State private var cards: [ToyotaCar] = []
//    @State private var isLoadingCars = false
//    
//    @State private var dragOffset = CGSize.zero
//    enum SwipeDirection { case left, right }
//    @State private var pendingSwipe: SwipeDirection? = nil
//    @State private var selectedTab = 0
//    @State private var liked: [ToyotaCar] = []
//    
//    @State private var birthday = Date()
//    @State private var selectedVibes: Set<String> = []
//    @State private var vibesExpanded = false
//    @State private var autoCloseTask: DispatchWorkItem? = nil
//    @State private var selectedCategory: String? = nil
//    @State private var selectedDetail: ToyotaCar? = nil
//    @State private var detailCompact: Bool = false
//    @State private var selectedCarTypes: Set<String> = []
//    @State private var selectedFuelTypes: Set<String> = []
//    @State private var selectedMpgOptions: Set<String> = []
//    @State private var selectedRanges: Set<String> = []
//    @State private var selectedSeatings: Set<String> = []
//    @State private var selectedPriceOptions: Set<String> = []
//    
//    // NEW: Financial Profile
//    @State private var selectedIncome: String? = nil
//    @State private var selectedCreditScore: String? = nil
//    
//    private let mpgOptions = ["< 20", "20–30", "> 30"]
//    private let rangeOptions = ["< 200 mi", "200–300 mi", "> 300 mi"]
//    private let seatingOptions = ["2 seats", "2–4 seats", "4+ seats"]
//    private let carTypes = ["Sedan", "SUV", "Coupe", "Hatchback", "Truck", "Van"]
//    private let fuelTypes = ["Gasoline", "Diesel", "Hybrid", "Electric", "Hydrogen"]
//    private let priceOptions = ["Under $30,000", "$30,000 - $50,000", "$50,000+"]
//    
//    private let categoryPresets: [(name: String, vibes: [String])] = [
//        ("Adventurous", ["Adventurous", "Energetic", "Spirited"]),
//        ("Classy", ["Classy", "Chic", "Timeless", "Luxurious"]),
//        ("Minimalist", ["Minimalist", "Timeless", "Sleek"]),
//        ("Sporty", ["Sporty", "Energetic", "Playful"]),
//        ("Chill", ["Chill", "Playful", "Fun"]),
//        ("Edgy", ["Edgy", "Rebellious", "Bold"]),
//        ("Trustworthy", ["Trustworthy", "Smart"]),
//        ("Luxurious", ["Luxurious", "Classy", "Bold"])
//    ]
//    
//    private let vibes = [
//        "Adventurous", "Confident", "Sporty", "Sleek", "Bold", "Playful",
//        "Classy", "Rugged", "Trustworthy", "Edgy", "Fun", "Luxurious",
//        "Minimalist", "Spirited", "Chic", "Chill", "Energetic", "Timeless",
//        "Rebellious", "Smart"
//    ]
//
//    var body: some View {
//        TabView(selection: $selectedTab) {
//            carsTab
//                .tabItem { Label("Cars", systemImage: "car.fill") }
//                .tag(0)
//
//            likesTab
//                .tabItem { Label("Likes", systemImage: "heart.fill") }
//                .tag(1)
//
//            profileTab
//                .tabItem { Label("Profile", systemImage: "person.circle.fill") }
//                .tag(2)
//        }
//        .background(Color.clear)
//        .sheet(item: $selectedDetail) { car in
//            EnhancedToyotaCardDetailSheetView(
//                car: car,
//                compact: detailCompact,
//                income: selectedIncome,
//                creditScore: selectedCreditScore
//            )
//        }
//    }
//
//    // MARK: - Cars Tab
//    private var carsTab: some View {
//        VStack {
//            ZStack(alignment: .bottom) {
//                if isLoadingCars {
//                    ProgressView("Loading cars...")
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                } else if cards.isEmpty {
//                    VStack(spacing: 20) {
//                        Text("No more cars")
//                            .font(.title2)
//                            .foregroundColor(.secondary)
//                        Button("Load More") {
//                            Task {
//                                await loadPersonalizedCars()
//                            }
//                        }
//                        .buttonStyle(.borderedProminent)
//                    }
//                } else {
//                    cardStack
//                    
//                    HStack(spacing: 36) {
//                        Button(action: { swipeCard(.left) }) {
//                            Image(systemName: "xmark.circle.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 64, height: 64)
//                                .foregroundColor(.red)
//                                .background(Circle().fill(.white).opacity(0.001))
//                        }
//
//                        Button(action: {
//                            if let top = cards.last {
//                                detailCompact = false
//                                selectedDetail = top
//                            }
//                        }) {
//                            Image(systemName: "info.circle.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 48, height: 48)
//                                .foregroundColor(.primary)
//                                .background(Circle().fill(.white).opacity(0.001))
//                        }
//
//                        Button(action: { swipeCard(.right) }) {
//                            Image(systemName: "heart.circle.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 64, height: 64)
//                                .foregroundColor(.green)
//                                .background(Circle().fill(.white).opacity(0.001))
//                        }
//                    }
//                    .padding(.bottom, 40)
//                    .shadow(radius: 8)
//                }
//            }
//        }
//        .onAppear {
//            interactionManager.loadFromUserDefaults()
//            Task {
//                if cards.isEmpty {
//                    await loadInitialCars()
//                }
//            }
//        }
//    }
//
//    // MARK: - Likes Tab
//    @ViewBuilder
//    private var likesTab: some View {
//        ScrollView {
//            if interactionManager.likes.isEmpty {
//                Text("No likes yet")
//                    .foregroundColor(.secondary)
//                    .padding(.top, 40)
//            } else {
//                let columns = [GridItem(.flexible()), GridItem(.flexible())]
//                LazyVGrid(columns: columns, spacing: 16) {
//                    ForEach(interactionManager.likes) { car in
//                        ToyotaLikedCardCell(car: car) {
//                            withAnimation {
//                                interactionManager.removeLike(car)
//                            }
//                        }
//                        .frame(height: 150)
//                        .onTapGesture {
//                            detailCompact = true
//                            selectedDetail = car
//                        }
//                    }
//                }
//                .padding()
//            }
//        }
//    }
//
//    // MARK: - Profile Tab
//    @ViewBuilder
//    private var profileTab: some View {
//        ScrollView {
//            VStack(spacing: 16) {
//                profileHeader
//                zodiacView
//                elementView
//                categoryPresetsView
//                vibesView
//                
//                // NEW: Financial Profile Section
//                financialProfileSection
//                
//                carTypeChips
//                fuelTypeChips
//                mpgChips
//                rangeChips
//                seatingChips
//                priceChips
//                Spacer()
//            }
//            .padding(.top, 24)
//        }
//        .onAppear { saveAndPrintPreferences() }
//        .onChange(of: birthday) { _ in saveAndPrintPreferences() }
//        .onChange(of: selectedVibes) { _ in saveAndPrintPreferences() }
//        .onChange(of: selectedCategory) { _ in saveAndPrintPreferences() }
//        .onChange(of: selectedCarTypes) { _ in saveAndPrintPreferences() }
//        .onChange(of: selectedFuelTypes) { _ in saveAndPrintPreferences() }
//        .onChange(of: selectedMpgOptions) { _ in saveAndPrintPreferences() }
//        .onChange(of: selectedRanges) { _ in saveAndPrintPreferences() }
//        .onChange(of: selectedSeatings) { _ in saveAndPrintPreferences() }
//        .onChange(of: selectedPriceOptions) { _ in saveAndPrintPreferences() }
//        .onChange(of: selectedIncome) { _ in saveAndPrintPreferences() }
//        .onChange(of: selectedCreditScore) { _ in saveAndPrintPreferences() }
//    }
//
//    // MARK: - Gemini Integration
//    
//    private func loadInitialCars() async {
//        print("\n🚀 Loading initial random cars from database...")
//        isLoadingCars = true
//        let newCars = await geminiService.getInitialCarsFromDatabase()
//        cards = newCars
//        print("✅ Loaded \(newCars.count) initial cars")
//        for car in newCars {
//            print("  - \(car.title) - $\(car.price)")
//        }
//        isLoadingCars = false
//    }
//
//    private func loadPersonalizedCars() async {
//        print("\n🎯 Loading personalized cars based on preferences...")
//        isLoadingCars = true
//        let prefs = currentPreferences()
//        let newCars = await geminiService.getPersonalizedCarsFromDatabase(
//            preferences: prefs,
//            likes: interactionManager.likes,
//            dislikes: interactionManager.dislikes
//        )
//        cards = newCars
//        
//        print("✅ Loaded \(newCars.count) personalized cars:")
//        for car in newCars {
//            print("  - \(car.title): \(car.matchReason ?? "No reason")")
//        }
//        
//        isLoadingCars = false
//    }
//
//    // MARK: - Swipe Logic
//    
//    private func swipeCard(_ direction: SwipeDirection) {
//        withAnimation(.spring()) {
//            dragOffset = CGSize(width: direction == .right ? 500 : -500, height: 0)
//            pendingSwipe = direction
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//            withAnimation {
//                if !cards.isEmpty {
//                    let currentCar = cards.last!
//                    
//                    if direction == .right {
//                        print("❤️ Liked: \(currentCar.title)")
//                        interactionManager.addLike(currentCar)
//                    } else {
//                        print("❌ Disliked: \(currentCar.title)")
//                        interactionManager.addDislike(currentCar)
//                    }
//                    
//                    cards.removeLast()
//                }
//                
//                if cards.isEmpty {
//                    print("\n📭 Out of cards! Loading personalized recommendations...")
//                    Task {
//                        await loadPersonalizedCars()
//                    }
//                }
//                
//                dragOffset = .zero
//                pendingSwipe = nil
//            }
//        }
//    }
//
//    // MARK: - Card Stack
//    
//    private var cardStack: some View {
//        ZStack {
//            ForEach(cards) { car in
//                cardView(for: car)
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .animation(.spring(), value: cards.count)
//        .ignoresSafeArea(edges: .top)
//    }
//
//    @ViewBuilder
//    private func cardView(for car: ToyotaCar) -> some View {
//        ToyotaCardView(car: car, imageService: imageService)
//            .offset(car.id == cards.last?.id ? dragOffset : .zero)
//            .gesture(
//                DragGesture()
//                    .onChanged { value in
//                        if pendingSwipe == nil && car.id == cards.last?.id {
//                            dragOffset = value.translation
//                        }
//                    }
//                    .onEnded { value in
//                        if pendingSwipe == nil && car.id == cards.last?.id {
//                            if value.translation.width > 100 {
//                                swipeCard(.right)
//                            } else if value.translation.width < -100 {
//                                swipeCard(.left)
//                            } else {
//                                withAnimation { dragOffset = .zero }
//                            }
//                        }
//                    }
//            )
//    }
//
//    // MARK: - Financial Profile Section (NEW)
//    
//    private var financialProfileSection: some View {
//        VStack(alignment: .leading, spacing: 16) {
//            Text("Financial Profile")
//                .font(.title2).bold()
//                .padding(.horizontal)
//            
//            // Annual Income
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Annual Income")
//                    .font(.headline)
//                    .padding(.horizontal)
//                
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 10) {
//                        ForEach(FinancialProfile.incomeRanges, id: \.self) { range in
//                            Button(action: {
//                                selectedIncome = range
//                            }) {
//                                Text(range)
//                                    .font(.subheadline).bold()
//                                    .padding(.vertical, 8)
//                                    .padding(.horizontal, 14)
//                                    .background(selectedIncome == range ? Color.green : Color(UIColor.secondarySystemBackground))
//                                    .foregroundColor(selectedIncome == range ? .white : .primary)
//                                    .clipShape(Capsule())
//                            }
//                            .buttonStyle(.plain)
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//            }
//            
//            // Credit Score
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Credit Score Range")
//                    .font(.headline)
//                    .padding(.horizontal)
//                
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 10) {
//                        ForEach(FinancialProfile.creditScoreRanges, id: \.self) { range in
//                            Button(action: {
//                                selectedCreditScore = range
//                            }) {
//                                Text(range)
//                                    .font(.subheadline).bold()
//                                    .padding(.vertical, 8)
//                                    .padding(.horizontal, 14)
//                                    .background(selectedCreditScore == range ? Color.green : Color(UIColor.secondarySystemBackground))
//                                    .foregroundColor(selectedCreditScore == range ? .white : .primary)
//                                    .clipShape(Capsule())
//                            }
//                            .buttonStyle(.plain)
//                        }
//                    }
//                    .padding(.horizontal)
//                }
//            }
//            
//            // Info Box
//            if let income = selectedIncome, let credit = selectedCreditScore {
//                VStack(alignment: .leading, spacing: 8) {
//                    HStack {
//                        Image(systemName: "info.circle.fill")
//                            .foregroundColor(.blue)
//                        Text("Your Financing Profile")
//                            .font(.headline)
//                    }
//                    
//                    Text("Based on your income and credit score, we recommend a maximum monthly payment of **$\(FinancialProfile.getMaxMonthlyPayment(income: income))** (15% of monthly income).")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                    
//                    Text("Your estimated interest rate: **\(String(format: "%.2f", FinancialProfile.getInterestRate(creditScore: credit)))%**")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//                .padding()
//                .background(RoundedRectangle(cornerRadius: 12).fill(Color.blue.opacity(0.1)))
//                .padding(.horizontal)
//            }
//        }
//        .padding(.vertical)
//    }
//
//    // MARK: - Profile Components
//    
//    private var carTypeChips: some View {
//        optionChips(title: "Car type", items: carTypes, selected: $selectedCarTypes)
//    }
//    private var fuelTypeChips: some View {
//        optionChips(title: "Fuel type", items: fuelTypes, selected: $selectedFuelTypes)
//    }
//    private var mpgChips: some View {
//        optionChips(title: "MPG", items: mpgOptions, selected: $selectedMpgOptions)
//    }
//    private var rangeChips: some View {
//        optionChips(title: "Range", items: rangeOptions, selected: $selectedRanges)
//    }
//    private var seatingChips: some View {
//        optionChips(title: "Seating", items: seatingOptions, selected: $selectedSeatings)
//    }
//    private var priceChips: some View {
//        optionChips(title: "Price", items: priceOptions, selected: $selectedPriceOptions)
//    }
//    private var profileHeader: some View {
//        Text("Profile")
//            .font(.title2).bold()
//            .padding(.horizontal)
//    }
//    private var zodiacView: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("Zodiac Sign")
//                .font(.headline)
//                .padding(.horizontal)
//            HStack(spacing: 12) {
//                Text(zodiacSign(for: birthday).emoji)
//                    .font(.system(size: 48))
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(zodiacSign(for: birthday).name)
//                        .font(.title3).bold()
//                    Text(zodiacSign(for: birthday).dateRange)
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//                Spacer()
//                DatePicker("", selection: $birthday, displayedComponents: .date)
//                    .datePickerStyle(.compact)
//                    .labelsHidden()
//            }
//            .padding()
//            .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground)))
//            .padding(.horizontal)
//        }
//    }
//    private var elementView: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("Element")
//                .font(.headline)
//                .padding(.horizontal)
//            HStack(spacing: 12) {
//                let el = element(for: birthday)
//                Text(el.emoji)
//                    .font(.system(size: 48))
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(el.name)
//                        .font(.title3).bold()
//                }
//                Spacer()
//            }
//            .padding()
//            .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground)))
//            .padding(.horizontal)
//        }
//    }
//    private var categoryPresetsView: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("How would you describe yourself?")
//                .font(.headline)
//                .padding(.horizontal)
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 10) {
//                    ForEach(categoryPresets.indices, id: \.self) { idx in
//                        categoryButton(for: categoryPresets[idx])
//                    }
//                }
//                .padding(.horizontal)
//            }
//        }
//        .padding(.horizontal)
//    }
//    private func categoryButton(for cat: (name: String, vibes: [String])) -> some View {
//        let isSelected = selectedCategory == cat.name
//        return Button(action: {
//            if isSelected {
//                selectedCategory = nil
//                selectedVibes.removeAll()
//                autoCloseTask?.cancel()
//                autoCloseTask = nil
//            } else {
//                selectedCategory = cat.name
//                selectedVibes = Set(cat.vibes)
//                withAnimation { vibesExpanded = true }
//                autoCloseTask?.cancel()
//                let task = DispatchWorkItem {
//                    DispatchQueue.main.async {
//                        withAnimation { vibesExpanded = false }
//                        autoCloseTask = nil
//                    }
//                }
//                autoCloseTask = task
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: task)
//            }
//        }) {
//            Text(cat.name)
//                .font(.subheadline).bold()
//                .padding(.vertical, 8)
//                .padding(.horizontal, 14)
//                .background(isSelected ? Color.blue : Color(UIColor.secondarySystemBackground))
//                .foregroundColor(isSelected ? .white : .primary)
//                .clipShape(Capsule())
//        }
//        .buttonStyle(.plain)
//    }
//    private var vibesView: some View {
//        DisclosureGroup(isExpanded: $vibesExpanded) {
//            let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]
//            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
//                ForEach(vibes.indices, id: \.self) { idx in
//                    vibeButton(for: vibes[idx])
//                }
//            }
//            .padding(.vertical, 8)
//        } label: {
//            HStack {
//                Text("Vibes")
//                    .font(.headline)
//                Spacer()
//                Image(systemName: vibesExpanded ? "chevron.up" : "chevron.down")
//                    .foregroundColor(.secondary)
//            }
//            .contentShape(Rectangle())
//        }
//        .animation(.easeInOut, value: vibesExpanded)
//        .padding(.horizontal)
//        .padding(.vertical, 4)
//        .background(RoundedRectangle(cornerRadius: 12).fill(Color(UIColor.secondarySystemBackground)))
//        .padding(.horizontal)
//    }
//    private func vibeButton(for vibe: String) -> some View {
//        let selected = selectedVibes.contains(vibe)
//        return Button(action: {
//            selectedCategory = nil
//            if selected {
//                selectedVibes.remove(vibe)
//            } else {
//                selectedVibes.insert(vibe)
//            }
//        }) {
//            HStack(spacing: 8) {
//                Text(vibe)
//                    .font(.subheadline).bold()
//                if selected {
//                    Image(systemName: "checkmark.circle.fill")
//                        .font(.system(size: 14))
//                }
//            }
//            .padding(.vertical, 8)
//            .padding(.horizontal, 12)
//            .background(selected ? Color.blue : Color(UIColor.secondarySystemBackground))
//            .foregroundColor(selected ? .white : .primary)
//            .clipShape(Capsule())
//        }
//        .buttonStyle(.plain)
//    }
//    private func optionChips(title: String, items: [String], selected: Binding<Set<String>>) -> some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text(title)
//                .font(.headline)
//                .padding(.horizontal)
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 10) {
//                    ForEach(items.indices, id: \.self) { idx in
//                        let item = items[idx]
//                        let isSelected = selected.wrappedValue.contains(item)
//                        Button(action: {
//                            if isSelected {
//                                selected.wrappedValue.remove(item)
//                            } else {
//                                selected.wrappedValue.insert(item)
//                            }
//                        }) {
//                            Text(item)
//                                .font(.subheadline).bold()
//                                .padding(.vertical, 8)
//                                .padding(.horizontal, 14)
//                                .background(isSelected ? Color.blue : Color(UIColor.secondarySystemBackground))
//                                .foregroundColor(isSelected ? .white : .primary)
//                                .clipShape(Capsule())
//                        }
//                        .buttonStyle(.plain)
//                    }
//                }
//                .padding(.horizontal)
//            }
//        }
//        .padding(.horizontal)
//    }
//}
//
//// MARK: - Toyota Card View
//struct ToyotaCardView: View {
//    let car: ToyotaCar
//    let imageService: CarImageService
//    @State private var imageURL: String = ""
//    
//    var body: some View {
//        GeometryReader { geo in
//            AsyncImage(url: URL(string: imageURL)) { phase in
//                switch phase {
//                case .empty:
//                    ProgressView()
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .background(Color.blue)
//                case .success(let image):
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                case .failure:
//                    Color.blue
//                        .overlay(
//                            VStack {
//                                Image(systemName: "car.fill")
//                                    .font(.system(size: 60))
//                                    .foregroundColor(.white.opacity(0.5))
//                                Text("Image unavailable")
//                                    .foregroundColor(.white.opacity(0.7))
//                            }
//                        )
//                @unknown default:
//                    Color.blue
//                }
//            }
//            .frame(width: geo.size.width, height: geo.size.height)
//            .clipShape(RoundedRectangle(cornerRadius: 25))
//            .overlay(
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(car.title)
//                        .font(.title).bold()
//                    Text("$\(car.price)")
//                        .font(.subheadline)
//                        .foregroundColor(.white.opacity(0.85))
//                }
//                .foregroundColor(.white)
//                .padding(.horizontal, 16)
//                .padding(.bottom, geo.safeAreaInsets.bottom + 215)
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
//            )
//            .shadow(radius: 5)
//        }
//        .task {
//            imageURL = await imageService.fetchImage(for: car)
//        }
//        .ignoresSafeArea()
//    }
//}
//
//// MARK: - Toyota Liked Card Cell
//struct ToyotaLikedCardCell: View {
//    let car: ToyotaCar
//    var onRemove: (() -> Void)? = nil
//
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 12)
//                .fill(Color.blue)
//                .shadow(radius: 3)
//            VStack {
//                Text(car.title)
//                    .foregroundColor(.white)
//                    .bold()
//                Text("$\(car.price)")
//                    .font(.caption)
//                    .foregroundColor(.white.opacity(0.8))
//            }
//        }
//        .overlay(alignment: .topTrailing) {
//            Button(action: { onRemove?() }) {
//                Image(systemName: "minus.circle.fill")
//                    .font(.system(size: 18))
//                    .foregroundColor(.white)
//                    .background(Circle().fill(Color.red).frame(width: 28, height: 28))
//            }
//            .buttonStyle(.plain)
//            .padding(8)
//        }
//        .clipShape(RoundedRectangle(cornerRadius: 12))
//    }
//}
//
//// MARK: - Enhanced Toyota Card Detail Sheet (NEW)
//struct EnhancedToyotaCardDetailSheetView: View {
//    let car: ToyotaCar
//    let compact: Bool
//    let income: String?
//    let creditScore: String?
//    @Environment(\.dismiss) private var dismiss
//
//    var body: some View {
//        VStack(spacing: 12) {
//            HStack {
//                Text(car.title)
//                    .font(.title2).bold()
//                Spacer()
//                Button(action: { dismiss() }) {
//                    Image(systemName: "xmark.circle.fill")
//                        .font(.system(size: 22))
//                        .foregroundColor(.secondary)
//                }
//                .buttonStyle(.plain)
//            }
//            .padding(.horizontal)
//            .padding(.top)
//
//            if compact {
//                ToyotaMiniCardPreview(car: car)
//                    .frame(height: 140)
//                    .padding(.horizontal)
//            }
//
//            Form {
//                Section(header: Text("Specifications")) {
//                    HStack { Text("Car type"); Spacer(); Text(car.carType).foregroundColor(.secondary) }
//                    HStack { Text("Fuel type"); Spacer(); Text(car.fuelType).foregroundColor(.secondary) }
//                    HStack { Text("MPG"); Spacer(); Text(car.mpg).foregroundColor(.secondary) }
//                    HStack { Text("Range"); Spacer(); Text(car.range).foregroundColor(.secondary) }
//                    HStack { Text("Seating"); Spacer(); Text(car.seating).foregroundColor(.secondary) }
//                    HStack { Text("Horsepower"); Spacer(); Text("\(car.horsepower) HP").foregroundColor(.secondary) }
//                    HStack { Text("Transmission"); Spacer(); Text(car.transmission).foregroundColor(.secondary) }
//                    HStack { Text("Color"); Spacer(); Text(car.color).foregroundColor(.secondary) }
//                }
//                
//                Section(header: Text("Description")) {
//                    Text(car.description)
//                }
//                
//                if let matchReason = car.matchReason {
//                    Section(header: Text("Why This Matches")) {
//                        Text(matchReason)
//                            .foregroundColor(.blue)
//                    }
//                }
//                
//                // NEW: Financing Section
//                Section(header: Text("Financing Options")) {
//                    FinancingPlanView(car: car, income: income, creditScore: creditScore)
//                }
//            }
//        }
//        .presentationDetents([.large])
//    }
//}
//
//private struct ToyotaMiniCardPreview: View {
//    let car: ToyotaCar
//    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 14)
//                .fill(Color.blue)
//                .shadow(radius: 3)
//            VStack(alignment: .leading, spacing: 6) {
//                Text(car.title)
//                    .font(.headline).bold()
//                    .foregroundColor(.white)
//                Text("$\(car.price)")
//                    .font(.subheadline)
//                    .foregroundColor(.white.opacity(0.9))
//            }
//            .padding(12)
//            .frame(maxWidth: .infinity, alignment: .leading)
//        }
//        .clipShape(RoundedRectangle(cornerRadius: 14))
//    }
//}
//
//#Preview {
//    ContentView()
//}
//
//// MARK: - Helper Functions
//private func zodiacSign(for date: Date) -> (name: String, emoji: String, dateRange: String) {
//    let comps = Calendar.current.dateComponents([.month, .day], from: date)
//    guard let m = comps.month, let d = comps.day else { return ("Unknown", "❓", "") }
//    switch (m, d) {
//    case (3, 21...31), (4, 1...19): return ("Aries", "♈️", "Mar 21 – Apr 19")
//    case (4, 20...30), (5, 1...20): return ("Taurus", "♉️", "Apr 20 – May 20")
//    case (5, 21...31), (6, 1...20): return ("Gemini", "♊️", "May 21 – Jun 20")
//    case (6, 21...30), (7, 1...22): return ("Cancer", "♋️", "Jun 21 – Jul 22")
//    case (7, 23...31), (8, 1...22): return ("Leo", "♌️", "Jul 23 – Aug 22")
//    case (8, 23...31), (9, 1...22): return ("Virgo", "♍️", "Aug 23 – Sep 22")
//    case (9, 23...30), (10, 1...22): return ("Libra", "♎️", "Sep 23 – Oct 22")
//    case (10, 23...31), (11, 1...21): return ("Scorpio", "♏️", "Oct 23 – Nov 21")
//    case (11, 22...30), (12, 1...21): return ("Sagittarius", "♐️", "Nov 22 – Dec 21")
//    case (12, 22...31), (1, 1...19): return ("Capricorn", "♑️", "Dec 22 – Jan 19")
//    case (1, 20...31), (2, 1...18): return ("Aquarius", "♒️", "Jan 20 – Feb 18")
//    case (2, 19...29), (3, 1...20): return ("Pisces", "♓️", "Feb 19 – Mar 20")
//    default: return ("Unknown", "❓", "")
//    }
//}
//
//private func element(for date: Date) -> (name: String, emoji: String) {
//    let sign = zodiacSign(for: date).name
//    let fire = Set(["Aries", "Leo", "Sagittarius"])
//    let earth = Set(["Taurus", "Virgo", "Capricorn"])
//    let air = Set(["Gemini", "Libra", "Aquarius"])
//    let water = Set(["Cancer", "Scorpio", "Pisces"])
//    if fire.contains(sign) { return ("Fire", "🔥") }
//    if earth.contains(sign) { return ("Earth", "🌍") }
//    if air.contains(sign) { return ("Air", "🌬️") }
//    if water.contains(sign) { return ("Water", "💧") }
//    return ("Unknown", "❓")
//}
//
//// MARK: - Preferences Extension
//extension ContentView {
//    private func currentPreferences() -> Preferences {
//        let z = zodiacSign(for: birthday)
//        let el = element(for: birthday)
//        return Preferences(
//            birthday: birthday,
//            selectedVibes: Array(selectedVibes),
//            selectedCategory: selectedCategory,
//            selectedCarTypes: Array(selectedCarTypes),
//            selectedFuelTypes: Array(selectedFuelTypes),
//            selectedMpgOptions: Array(selectedMpgOptions),
//            selectedRanges: Array(selectedRanges),
//            selectedSeatings: Array(selectedSeatings),
//            selectedPriceOptions: Array(selectedPriceOptions),
//            selectedTab: selectedTab,
//            zodiacName: z.name,
//            zodiacEmoji: z.emoji,
//            zodiacDateRange: z.dateRange,
//            elementName: el.name,
//            elementEmoji: el.emoji,
//            // NEW: Financial fields
//            annualIncome: selectedIncome,
//            creditScore: selectedCreditScore
//        )
//    }
//    
//    private func applyPreferences(_ p: Preferences) {
//        birthday = p.birthday
//        selectedVibes = Set(p.selectedVibes)
//        selectedCategory = p.selectedCategory
//        selectedCarTypes = Set(p.selectedCarTypes)
//        selectedFuelTypes = Set(p.selectedFuelTypes)
//        selectedMpgOptions = Set(p.selectedMpgOptions)
//        selectedRanges = Set(p.selectedRanges)
//        selectedSeatings = Set(p.selectedSeatings)
//        selectedPriceOptions = Set(p.selectedPriceOptions)
//        selectedTab = p.selectedTab
//        // NEW: Apply financial fields
//        selectedIncome = p.annualIncome
//        selectedCreditScore = p.creditScore
//    }
//    
//    private func saveAndPrintPreferences() {
//        Task {
//            do {
//                _ = try exportPreferencesJSON()
//                _ = try savePreferencesToDocuments()
//            } catch {
//                print("Auto-save error:", error)
//            }
//        }
//    }
//    
//    func exportPreferencesJSON() throws -> String {
//        let encoder = JSONEncoder()
//        encoder.dateEncodingStrategy = .iso8601
//        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
//        let data = try encoder.encode(currentPreferences())
//        let json = String(data: data, encoding: .utf8) ?? ""
//        print("Preferences JSON:\n\(json)")
//        return json
//    }
//    
//    func importPreferencesJSON(_ json: String) throws {
//        let decoder = JSONDecoder()
//        decoder.dateDecodingStrategy = .iso8601
//        guard let data = json.data(using: .utf8) else { throw NSError(domain: "Import", code: 1) }
//        let prefs = try decoder.decode(Preferences.self, from: data)
//        applyPreferences(prefs)
//    }
//    
//    func savePreferencesToDocuments() throws -> URL {
//        let json = try exportPreferencesJSON()
//        let fm = FileManager.default
//        let docs = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//        let file = docs.appendingPathComponent("preferences.json")
//        try Data(json.utf8).write(to: file, options: .atomic)
//        print("Saved preferences to: \(file.path)")
//        return file
//    }
//    
//    func loadPreferencesFromDocuments() throws {
//        let fm = FileManager.default
//        let docs = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//        let file = docs.appendingPathComponent("preferences.json")
//        guard fm.fileExists(atPath: file.path) else {
//            print("No preferences.json found at: \(file.path)")
//            return
//        }
//        let data = try Data(contentsOf: file)
//        let json = String(data: data, encoding: .utf8) ?? ""
//        print("Loaded preferences JSON (not imported):\n\(json)")
//    }
//}
