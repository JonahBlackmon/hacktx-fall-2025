// FinancingFeature.swift
// Supporting code for financing calculations - NO VIEW DUPLICATES

import SwiftUI
import Foundation

// MARK: - Financial Profile Options

struct FinancialProfile {
    static let incomeRanges = [
        "Under $30,000",
        "$30,000 - $50,000",
        "$50,000 - $75,000",
        "$75,000 - $100,000",
        "$100,000 - $150,000",
        "$150,000+"
    ]
    
    static let creditScoreRanges = [
        "Poor (300-579)",
        "Fair (580-669)",
        "Good (670-739)",
        "Very Good (740-799)",
        "Excellent (800-850)"
    ]
    
    static func getInterestRate(creditScore: String) -> Double {
        switch creditScore {
        case "Excellent (800-850)": return 3.99
        case "Very Good (740-799)": return 5.49
        case "Good (670-739)": return 7.99
        case "Fair (580-669)": return 10.99
        case "Poor (300-579)": return 14.99
        default: return 8.99
        }
    }
    
    static func getMaxMonthlyPayment(income: String) -> Int {
        // Rule: Car payment should be 10-15% of gross monthly income
        let lowerBound: Int
        switch income {
        case "Under $30,000": lowerBound = 20000
        case "$30,000 - $50,000": lowerBound = 30000
        case "$50,000 - $75,000": lowerBound = 50000
        case "$75,000 - $100,000": lowerBound = 75000
        case "$100,000 - $150,000": lowerBound = 100000
        case "$150,000+": lowerBound = 150000
        default: lowerBound = 40000
        }
        
        let monthlyIncome = lowerBound / 12
        return Int(Double(monthlyIncome) * 0.15) // 15% of monthly income
    }
}

// MARK: - Financing Plan Model

struct FinancingPlan: Codable, Identifiable {
    let id = UUID()
    let termMonths: Int
    let monthlyPayment: Double
    let totalInterest: Double
    let totalCost: Double
    let downPayment: Double
    let interestRate: Double
    let recommendation: String
    
    enum CodingKeys: String, CodingKey {
        case termMonths, monthlyPayment, totalInterest, totalCost, downPayment, interestRate, recommendation
    }
}

// MARK: - Enhanced ToyotaCar Extension with Financing

extension Car {
    func calculateFinancingPlans(
        creditScore: String,
        income: String,
        downPaymentPercent: Double = 0.10
    ) -> [FinancingPlan] {
        let interestRate = FinancialProfile.getInterestRate(creditScore: creditScore)
        let downPayment = Double(price) * downPaymentPercent
        let loanAmount = Double(price) - downPayment
        let maxMonthly = Double(FinancialProfile.getMaxMonthlyPayment(income: income))
        
        var plans: [FinancingPlan] = []
        let terms = [36, 48, 60, 72] // months
        
        for term in terms {
            let monthlyRate = interestRate / 100 / 12
            let numPayments = Double(term)
            
            // Calculate monthly payment: P * [r(1+r)^n] / [(1+r)^n - 1]
            let monthlyPayment = loanAmount * (monthlyRate * pow(1 + monthlyRate, numPayments)) / (pow(1 + monthlyRate, numPayments) - 1)
            
            let totalPaid = monthlyPayment * numPayments
            let totalInterest = totalPaid - loanAmount
            let totalCost = totalPaid + downPayment
            
            // Generate recommendation
            var recommendation = ""
            if monthlyPayment <= maxMonthly * 0.8 {
                recommendation = "✅ Excellent fit - Payment is comfortable for your budget"
            } else if monthlyPayment <= maxMonthly {
                recommendation = "✓ Good option - Within your recommended budget"
            } else {
                recommendation = "⚠️ Stretches budget - Consider longer term or higher down payment"
            }
            
            plans.append(FinancingPlan(
                termMonths: term,
                monthlyPayment: monthlyPayment,
                totalInterest: totalInterest,
                totalCost: totalCost,
                downPayment: downPayment,
                interestRate: interestRate,
                recommendation: recommendation
            ))
        }
        
        return plans
    }
    
    func getBestFinancingPlan(creditScore: String, income: String) -> FinancingPlan? {
        let plans = calculateFinancingPlans(creditScore: creditScore, income: income)
        let maxMonthly = Double(FinancialProfile.getMaxMonthlyPayment(income: income))
        
        // Find the plan with the lowest total interest that fits the budget
        return plans
            .filter { $0.monthlyPayment <= maxMonthly }
            .min(by: { $0.totalInterest < $1.totalInterest })
    }
}

// MARK: - Financing Plan View Component

struct FinancingPlanView: View {
    let car: Car
    let income: String?
    let creditScore: String?
    
    var body: some View {
        if let income = income, let creditScore = creditScore {
            VStack(alignment: .leading, spacing: 12) {
                Text("💰 Financing Options")
                    .font(.headline)
                
                let plans = car.calculateFinancingPlans(creditScore: creditScore, income: income)
                
                ForEach(plans) { plan in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("\(plan.termMonths)-Month Plan")
                                .font(.subheadline).bold()
                            Spacer()
                            Text("\(String(format: "%.2f", plan.interestRate))% APR")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("$\(Int(plan.monthlyPayment))/mo")
                                    .font(.title3).bold()
                                    .foregroundColor(.green)
                                Text("Monthly Payment")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("$\(Int(plan.totalCost))")
                                    .font(.subheadline).bold()
                                Text("Total Cost")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text(plan.recommendation)
                            .font(.caption)
                            .foregroundColor(plan.recommendation.contains("✅") ? .green :
                                           plan.recommendation.contains("⚠️") ? .orange : .blue)
                            .padding(.vertical, 4)
                        
                        HStack {
                            Text("Down Payment: $\(Int(plan.downPayment))")
                            Spacer()
                            Text("Interest: $\(Int(plan.totalInterest))")
                        }
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color(UIColor.secondarySystemBackground)))
                }
                
                // Best Plan Recommendation
                if let bestPlan = car.getBestFinancingPlan(creditScore: creditScore, income: income) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Recommended Plan")
                                .font(.headline)
                        }
                        
                        Text("\(bestPlan.termMonths)-month term at $\(Int(bestPlan.monthlyPayment))/month")
                            .font(.subheadline)
                        
                        Text("This plan offers the best balance of affordable payments and minimal interest.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.yellow.opacity(0.1)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.yellow, lineWidth: 2)
                    )
                }
            }
        } else {
            VStack(spacing: 12) {
                Image(systemName: "dollarsign.circle")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                
                Text("Add Financial Profile")
                    .font(.headline)
                
                Text("Go to your Profile tab and add your income and credit score to see personalized financing options.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding()
        }
    }
}

// MARK: - Optional: Filter Cars by Affordability

extension ToyotaDatabase {
    func getAffordableCars(preferences: Preferences, count: Int) -> [Car] {
        var filtered = vehicles
        
        // Filter by income if provided
        if let income = preferences.annualIncome {
            let maxMonthly = FinancialProfile.getMaxMonthlyPayment(income: income)
            // Assume 60-month loan with 10% down
            let maxAffordablePrice = (maxMonthly * 60) + (maxMonthly * 60 / 9) // Add back down payment
            filtered = filtered.filter { $0.price <= maxAffordablePrice }
        }
        
        // Apply other preference filters
        if !preferences.selectedCarTypes.isEmpty {
            filtered = filtered.filter { preferences.selectedCarTypes.contains($0.carType) }
        }
        
        if !preferences.selectedFuelTypes.isEmpty {
            filtered = filtered.filter { preferences.selectedFuelTypes.contains($0.fuelType) }
        }
        
        let shuffled = filtered.shuffled()
        let selected = Array(shuffled.prefix(count))
        return selected.map { convertToCar($0) }
    }
}
