//
//  CarDetailSheetView.swift
//  Cinder
//
//  Created by Jonah Blackmon on 10/19/25.
//

import SwiftUI

struct CarDetailSheetView: View {
    let car: Car
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // Celestial background
            Color.black.opacity(0.95)
                .ignoresSafeArea()
            
            // Subtle starfield
            GeometryReader { geometry in
                ForEach(0..<30, id: \.self) { index in
                    Circle()
                        .fill(
                            index % 3 == 0 ? Color.white.opacity(Double.random(in: 0.3...0.6)) :
                            index % 3 == 1 ? Color.blue.opacity(Double.random(in: 0.2...0.4)) :
                            Color.purple.opacity(Double.random(in: 0.2...0.4))
                        )
                        .frame(width: CGFloat.random(in: 1...2))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                }
            }
            
            ScrollView {
                VStack(spacing: 20) {
                    // Header with close button
                    header
                    
                    // Car title card
                    titleCard
                    
                    // Specifications card
                    specificationsCard
                    
                    // Description card
                    descriptionCard
                    
                    // Match reason card (if available)
                    if car.matchReason != nil {
                        matchReasonCard
                    }
                    
                    // Financing card
                    if settingsManager.selectedIncome != nil && settingsManager.selectedCreditScore != nil {
                        financingCard
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Header
    
    private var header: some View {
        HStack {
            Spacer()
            Button(action: { dismiss() }) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 36, height: 36)
                        .blur(radius: 8)
                    
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white.opacity(0.9), .blue.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 8)
    }
    
    // MARK: - Title Card
    
    private var titleCard: some View {
        CelestialDetailCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    // Car icon
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 50, height: 50)
                            .blur(radius: 10)
                        
                        Image(systemName: "car.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.white, .blue.opacity(0.9)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(car.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white.opacity(0.95))
                        
                        Text("$\(car.price)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.green.opacity(0.9), .blue.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    }
                    
                    Spacer()
                }
            }
        }
    }
    
    // MARK: - Specifications Card
    
    private var specificationsCard: some View {
        CelestialDetailCard {
            VStack(alignment: .leading, spacing: 16) {
                DetailSectionHeader(title: "Specifications", icon: "wrench.and.screwdriver.fill")
                
                VStack(spacing: 12) {
                    SpecificationRow(label: "Car Type", value: car.carType, icon: "car.fill")
                    Divider().background(Color.white.opacity(0.1))
                    
                    SpecificationRow(label: "Fuel Type", value: car.fuelType, icon: "fuelpump.fill")
                    Divider().background(Color.white.opacity(0.1))
                    
                    SpecificationRow(label: "MPG", value: car.mpg, icon: "gauge.medium")
                    Divider().background(Color.white.opacity(0.1))
                    
                    SpecificationRow(label: "Range", value: car.range, icon: "road.lanes")
                    Divider().background(Color.white.opacity(0.1))
                    
                    SpecificationRow(label: "Seating", value: car.seating, icon: "person.3.fill")
                    Divider().background(Color.white.opacity(0.1))
                    
                    SpecificationRow(label: "Horsepower", value: "\(car.horsepower) HP", icon: "bolt.fill")
                    Divider().background(Color.white.opacity(0.1))
                    
                    SpecificationRow(label: "Transmission", value: car.transmission, icon: "gearshape.fill")
                    Divider().background(Color.white.opacity(0.1))
                    
                    SpecificationRow(label: "Color", value: car.color, icon: "paintpalette.fill")
                }
            }
        }
    }
    
    // MARK: - Description Card
    
    private var descriptionCard: some View {
        CelestialDetailCard {
            VStack(alignment: .leading, spacing: 12) {
                DetailSectionHeader(title: "Description", icon: "text.alignleft")
                
                Text(car.description)
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .lineSpacing(4)
            }
        }
    }
    
    // MARK: - Match Reason Card
    
    private var matchReasonCard: some View {
        CelestialDetailCard {
            VStack(alignment: .leading, spacing: 12) {
                DetailSectionHeader(title: "Why This Matches You", icon: "sparkles")
                
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.yellow.opacity(0.9), .orange.opacity(0.8)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    Text(car.matchReason ?? "")
                        .font(.body)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white.opacity(0.9), .blue.opacity(0.8)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .lineSpacing(4)
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.blue.opacity(0.15),
                                    Color.purple.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
    
    // MARK: - Financing Card
    
    private var financingCard: some View {
        CelestialDetailCard {
            VStack(alignment: .leading, spacing: 16) {
                DetailSectionHeader(title: "Financing Options", icon: "dollarsign.circle.fill")
                
                if let income = settingsManager.selectedIncome,
                   let creditScore = settingsManager.selectedCreditScore {
                    
                    let interestRate = getInterestRate(for: creditScore)
                    let maxMonthly = getMaxMonthlyPayment(for: income)
                    let estimatedMonthly = calculateMonthlyPayment(
                        price: Double(car.price),
                        interestRate: interestRate,
                        months: 60
                    )
                    
                    // Financial summary boxes
                    HStack(spacing: 12) {
                        FinancialMetricBox(
                            title: "Interest Rate",
                            value: String(format: "%.2f%%", interestRate),
                            icon: "percent"
                        )
                        
                        FinancialMetricBox(
                            title: "Max Monthly",
                            value: "$\(maxMonthly)",
                            icon: "creditcard.fill"
                        )
                    }
                    
                    // Monthly payment estimate
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Estimated Monthly Payment (60 months)")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.8))
                        
                        HStack(alignment: .firstTextBaseline, spacing: 6) {
                            Text("$\(Int(estimatedMonthly))")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.green.opacity(0.9), .blue.opacity(0.8)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            
                            Text("/mo")
                                .font(.title3)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color.green.opacity(0.15),
                                        Color.blue.opacity(0.1)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                estimatedMonthly <= Double(maxMonthly) ?
                                Color.green.opacity(0.4) : Color.red.opacity(0.4),
                                lineWidth: 1
                            )
                    )
                    
                    // Affordability indicator
                    HStack(spacing: 8) {
                        Image(systemName: estimatedMonthly <= Double(maxMonthly) ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                            .foregroundColor(estimatedMonthly <= Double(maxMonthly) ? .green : .orange)
                        
                        Text(estimatedMonthly <= Double(maxMonthly) ?
                             "This fits your budget" :
                             "This exceeds your recommended budget")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 4)
                    
                } else {
                    Text("Complete your financial profile to see financing options")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.05))
                        )
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func getInterestRate(for creditScore: String) -> Double {
        switch creditScore {
        case "750+": return 3.5
        case "700-749": return 4.5
        case "650-699": return 6.0
        case "600-649": return 8.0
        case "Below 600": return 12.0
        default: return 7.0
        }
    }
    
    private func getMaxMonthlyPayment(for income: String) -> Int {
        switch income {
        case "Under $30,000": return 375
        case "$30,000 - $50,000": return 625
        case "$50,000 - $75,000": return 937
        case "$75,000 - $100,000": return 1250
        case "$100,000+": return 1667
        default: return 500
        }
    }
    
    private func calculateMonthlyPayment(price: Double, interestRate: Double, months: Int) -> Double {
        let monthlyRate = interestRate / 100 / 12
        let principal = price * 0.9 // Assuming 10% down payment
        
        if monthlyRate == 0 { return principal / Double(months) }
        
        let payment = principal * (monthlyRate * pow(1 + monthlyRate, Double(months))) /
                     (pow(1 + monthlyRate, Double(months)) - 1)
        return payment
    }
}

// MARK: - Supporting Views

struct CelestialDetailCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.1),
                            Color.blue.opacity(0.2),
                            Color.purple.opacity(0.2)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .blur(radius: 10)
                .padding(-6)
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.05))
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.1, green: 0.1, blue: 0.2).opacity(0.7),
                                    Color(red: 0.05, green: 0.05, blue: 0.15).opacity(0.8)
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
                                    Color.blue.opacity(0.3),
                                    Color.purple.opacity(0.3),
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

struct DetailSectionHeader: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 32, height: 32)
                    .blur(radius: 8)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .blue.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.95))
            
            Spacer()
        }
    }
}

struct SpecificationRow: View {
    let label: String
    let value: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.blue.opacity(0.7))
                .frame(width: 24)
            
            Text(label)
                .font(.body)
                .foregroundColor(.white.opacity(0.7))
            
            Spacer()
            
            Text(value)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.95))
        }
    }
}

struct FinancialMetricBox: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .blue.opacity(0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white.opacity(0.95))
            
            Text(title)
                .font(.caption)
                .foregroundColor(.white.opacity(0.6))
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.white.opacity(0.08),
                            Color.white.opacity(0.04)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
    }
}
