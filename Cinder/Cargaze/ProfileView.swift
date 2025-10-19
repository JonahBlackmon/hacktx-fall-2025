//
//  ProfileView.swift
//  Cinder
//
//  Created by Jonah Blackmon on 10/19/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var vibesExpanded = false
    @State private var autoCloseTask: DispatchWorkItem? = nil
    
    var body: some View {
        ZStack {
            // Semi-transparent overlay
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            
            // Mystical stars overlay
            GeometryReader { geometry in
                ForEach(0..<50, id: \.self) { index in
                    Circle()
                        .fill(
                            index % 3 == 0 ? Color.white.opacity(Double.random(in: 0.4...0.8)) :
                            index % 3 == 1 ? Color.red.opacity(Double.random(in: 0.3...0.6)) :
                            Color.pink.opacity(Double.random(in: 0.3...0.6))
                        )
                        .frame(width: CGFloat.random(in: 1...3))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .blur(radius: index % 5 == 0 ? 0 : 1)
                }
            }
            
            ScrollView {
                VStack(spacing: 24) {
                    profileHeader
                    
                    VStack(spacing: 16) {
                        zodiacCard
                        elementCard
                        categoryPresetsCard
                        vibesCard
                        financialProfileCard
                        carPreferencesCard
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 100)
                }
                .padding(.top, 20)
            }
        }
    }
    
    // MARK: - Header
    
    private var profileHeader: some View {
        Text("Your Cosmic Profile")
            .font(.system(size: 32, weight: .bold))
            .foregroundStyle(
                LinearGradient(
                    colors: [.white, .red.opacity(0.9), Color.beige.opacity(0.8)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .shadow(color: .white.opacity(0.3), radius: 10)
            .padding(.horizontal, 16)
    }
    
    // MARK: - Zodiac Card
    
    private var zodiacCard: some View {
        CelestialCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Zodiac Sign", icon: "sparkles")
                
                HStack(spacing: 16) {
                    // Zodiac emoji with glow
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 70, height: 70)
                            .blur(radius: 15)
                        
                        Text(settingsManager.zodiacSign.emoji)
                            .font(.system(size: 48))
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(settingsManager.zodiacSign.name)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.95))
                        
                        Text(settingsManager.zodiacSign.dateRange)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    DatePicker("", selection: $settingsManager.birthday, displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .colorScheme(.dark)
                }
            }
        }
    }
    
    // MARK: - Element Card
    
    private var elementCard: some View {
        CelestialCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Element", icon: "flame.fill")
                
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 70, height: 70)
                            .blur(radius: 15)
                        
                        Text(settingsManager.element.emoji)
                            .font(.system(size: 48))
                    }
                    
                    Text(settingsManager.element.name)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.95))
                    
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Category Presets Card
    
    private var categoryPresetsCard: some View {
        CelestialCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "How would you describe yourself?", icon: "person.fill")
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(settingsManager.categoryPresets, id: \.name) { category in
                            CategoryButton(
                                category: category,
                                isSelected: settingsManager.selectedCategory == category.name,
                                onSelect: { handleCategorySelection(category) }
                            )
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Vibes Card
    
    private var vibesCard: some View {
        CelestialCard {
            VStack(alignment: .leading, spacing: 12) {
                Button(action: {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        vibesExpanded.toggle()
                    }
                }) {
                    HStack {
                        SectionHeader(title: "Vibes", icon: "waveform")
                        Spacer()
                        Image(systemName: vibesExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.white.opacity(0.6))
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .buttonStyle(.plain)
                
                if vibesExpanded {
                    let columns = [GridItem(.adaptive(minimum: 100), spacing: 10)]
                    LazyVGrid(columns: columns, alignment: .leading, spacing: 10) {
                        ForEach(settingsManager.vibes, id: \.self) { vibe in
                            VibeButton(
                                vibe: vibe,
                                isSelected: settingsManager.selectedVibes.contains(vibe),
                                onToggle: { toggleVibe(vibe) }
                            )
                        }
                    }
                    .padding(.top, 4)
                }
            }
        }
    }
    
    // MARK: - Financial Profile Card
    
    private var financialProfileCard: some View {
        CelestialCard {
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(title: "Financial Profile", icon: "dollarsign.circle.fill")
                
                // Annual Income
                VStack(alignment: .leading, spacing: 8) {
                    Text("Annual Income")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.8))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(settingsManager.incomeRanges, id: \.self) { range in
                                OptionChip(
                                    text: range,
                                    isSelected: settingsManager.selectedIncome == range,
                                    onTap: { settingsManager.selectedIncome = range }
                                )
                            }
                        }
                    }
                }
                
                // Credit Score
                VStack(alignment: .leading, spacing: 8) {
                    Text("Credit Score Range")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.8))
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(settingsManager.creditScoreRanges, id: \.self) { range in
                                OptionChip(
                                    text: range,
                                    isSelected: settingsManager.selectedCreditScore == range,
                                    onTap: { settingsManager.selectedCreditScore = range }
                                )
                            }
                        }
                    }
                }
                
                // Financial Info Box
                if let income = settingsManager.selectedIncome,
                   let credit = settingsManager.selectedCreditScore {
                    FinancialInfoBox(income: income, creditScore: credit)
                        .padding(.top, 8)
                }
            }
        }
    }
    
    // MARK: - Car Preferences Card
    
    private var carPreferencesCard: some View {
        CelestialCard {
            VStack(alignment: .leading, spacing: 16) {
                SectionHeader(title: "Car Preferences", icon: "car.fill")
                
                PreferenceSection(
                    title: "Car Type",
                    options: settingsManager.carTypes,
                    selected: $settingsManager.selectedCarTypes
                )
                
                PreferenceSection(
                    title: "Fuel Type",
                    options: settingsManager.fuelTypes,
                    selected: $settingsManager.selectedFuelTypes
                )
                
                PreferenceSection(
                    title: "MPG",
                    options: settingsManager.mpgOptions,
                    selected: $settingsManager.selectedMpgOptions
                )
                
                PreferenceSection(
                    title: "Range",
                    options: settingsManager.rangeOptions,
                    selected: $settingsManager.selectedRanges
                )
                
                PreferenceSection(
                    title: "Seating",
                    options: settingsManager.seatingOptions,
                    selected: $settingsManager.selectedSeatings
                )
                
                PreferenceSection(
                    title: "Price Range",
                    options: settingsManager.priceOptions,
                    selected: $settingsManager.selectedPriceOptions
                )
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func handleCategorySelection(_ category: CategoryPreset) {
        if settingsManager.selectedCategory == category.name {
            settingsManager.selectedCategory = nil
            settingsManager.selectedVibes.removeAll()
            autoCloseTask?.cancel()
        } else {
            settingsManager.selectedCategory = category.name
            settingsManager.selectedVibes = Set(category.vibes)
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                vibesExpanded = true
            }
            
            autoCloseTask?.cancel()
            let task = DispatchWorkItem {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    vibesExpanded = false
                }
            }
            autoCloseTask = task
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: task)
        }
    }
    
    private func toggleVibe(_ vibe: String) {
        settingsManager.selectedCategory = nil
        if settingsManager.selectedVibes.contains(vibe) {
            settingsManager.selectedVibes.remove(vibe)
        } else {
            settingsManager.selectedVibes.insert(vibe)
        }
    }
}

// MARK: - Supporting Views

struct CelestialCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            // Outer glow
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.1),
                            Color.red.opacity(0.2),
                            Color.pink.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .blur(radius: 10)
                .padding(-6)
            
            // Card background
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .background(
                    RoundedRectangle(cornerRadius: 16)
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
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.3),
                                    Color.red.opacity(0.3),
                                    Color.pink.opacity(0.3),
                                    Color.white.opacity(0.3)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            
            content
                .padding(20)
        }
        .shadow(color: .white.opacity(0.1), radius: 10)
    }
}

struct SectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .red.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.95))
        }
    }
}

struct CategoryButton: View {
    let category: CategoryPreset
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            Text(category.name)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.vertical, 10)
                .padding(.horizontal, 16)
                .background(
                    isSelected ?
                    LinearGradient(
                        colors: [.red.opacity(0.8), .pink.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ) :
                    LinearGradient(
                        colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white.opacity(isSelected ? 1 : 0.7))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(
                            isSelected ? Color.white.opacity(0.3) : Color.white.opacity(0.2),
                            lineWidth: 1
                        )
                )
                .shadow(color: isSelected ? .red.opacity(0.3) : .clear, radius: 8)
        }
        .buttonStyle(.plain)
    }
}

struct VibeButton: View {
    let vibe: String
    let isSelected: Bool
    let onToggle: () -> Void
    
    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 6) {
                Text(vibe)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12))
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                isSelected ?
                LinearGradient(
                    colors: [.red.opacity(0.8), .pink.opacity(0.7)],
                    startPoint: .leading,
                    endPoint: .trailing
                ) :
                LinearGradient(
                    colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .foregroundColor(.white.opacity(isSelected ? 1 : 0.7))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(
                        isSelected ? Color.white.opacity(0.3) : Color.white.opacity(0.2),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

struct OptionChip: View {
    let text: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            Text(text)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(
                    isSelected ?
                    LinearGradient(
                        colors: [.red.opacity(0.8), .pink.opacity(0.7)],
                        startPoint: .leading,
                        endPoint: .trailing
                    ) :
                    LinearGradient(
                        colors: [Color.white.opacity(0.1), Color.white.opacity(0.05)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white.opacity(isSelected ? 1 : 0.7))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(
                            isSelected ? Color.white.opacity(0.3) : Color.white.opacity(0.2),
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

struct FinancialInfoBox: View {
    let income: String
    let creditScore: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.red, .pink],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("Your Financing Profile")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white.opacity(0.95))
            }
            
            Text("Based on your income and credit score, we recommend a maximum monthly payment of **$\(maxMonthlyPayment(for: income))** (15% of monthly income).")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
            
            Text("Your estimated interest rate: **\(String(format: "%.2f", interestRate(for: creditScore)))%**")
                .font(.caption)
                .foregroundColor(.white.opacity(0.7))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.red.opacity(0.15),
                            Color.pink.opacity(0.1)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.3), lineWidth: 1)
        )
    }
    
    private func maxMonthlyPayment(for income: String) -> Int {
        // Simplified calculation - in real app, use FinancialProfile
        switch income {
        case "Under $30,000": return 375
        case "$30,000 - $50,000": return 625
        case "$50,000 - $75,000": return 937
        case "$75,000 - $100,000": return 1250
        case "$100,000+": return 1667
        default: return 500
        }
    }
    
    private func interestRate(for creditScore: String) -> Double {
        // Simplified calculation - in real app, use FinancialProfile
        switch creditScore {
        case "750+": return 3.5
        case "700-749": return 4.5
        case "650-699": return 6.0
        case "600-649": return 8.0
        case "Below 600": return 12.0
        default: return 7.0
        }
    }
}

struct PreferenceSection: View {
    let title: String
    let options: [String]
    @Binding var selected: Set<String>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.8))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(options, id: \.self) { option in
                        OptionChip(
                            text: option,
                            isSelected: selected.contains(option),
                            onTap: {
                                if selected.contains(option) {
                                    selected.remove(option)
                                } else {
                                    selected.insert(option)
                                }
                            }
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(SettingsManager())
}
