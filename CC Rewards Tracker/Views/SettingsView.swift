//
//  SettingsView.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/11/21.
//

import SwiftUI
import CoreData

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var isSettingsPresented: Bool
    
    @State private var showPrefillGoldAlert = false
    @State private var showPrefillHiltonAspireAlert = false
    @State private var showPrefillRicardoAlert = false
    @State private var showResetGoldAlert = false
    
    let currentYear: Int = 2024
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Settings")
                .font(.largeTitle)
                .padding()
            
            Button(action: {
                isSettingsPresented = false
            }) {
                Text("Leave Settings")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                showPrefillGoldAlert = true
            }) {
                Text("Add Gold Card Rewards")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showPrefillGoldAlert) {
                Alert(
                    title: Text("Add Amex Gold Rewards"),
                    message: Text("Do you want to prefill all Amex Gold rewards? Don't click this more than once or it may reset previous run."),
                    primaryButton: .destructive(Text("Add Gold Rewards")) {
                        updatePrefillGoldRewards()
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Button(action: {
                showPrefillHiltonAspireAlert = true
            }) {
                Text("Add Hilton Aspire Rewards")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showPrefillHiltonAspireAlert) {
                Alert(
                    title: Text("Add Hilton Aspire Rewards"),
                    message: Text("Do you want to prefill all Amex Hilton Aspire rewards?"),
                    primaryButton: .destructive(Text("Add My Rewards")) {
                        updatePrefillHiltonAspireRewards()
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Button(action: {
                showPrefillRicardoAlert = true
            }) {
                Text("Add Dan's 2024 Rewards")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showPrefillRicardoAlert) {
                Alert(
                    title: Text("Add Dan's Rewards"),
                    message: Text("Do you want to prefill all Amex rewards? Don't click this more than once or it may reset previous run."),
                    primaryButton: .destructive(Text("Add My Rewards")) {
                        updatePrefillGoldRewards()
                        updatePrefillPlatinumRewards()
                        updatePrefillDeltaGoldRewards()
                        updatePrefillDeltaReserveRewards()
                        updatePrefillHiltonAspireRewards()
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Button(action: {
                showPrefillRicardoAlert = true
            }) {
                Text("Add Ricardo's Rewards")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showPrefillRicardoAlert) {
                Alert(
                    title: Text("Add Ricardo's Rewards"),
                    message: Text("Do you want to prefill all Amex rewards? Don't click this more than once or it may reset previous run."),
                    primaryButton: .destructive(Text("Add My Rewards")) {
                        updatePrefillGoldRewards()
                        updatePrefillPlatinumRewards()
                        updatePrefillDeltaPlatinumRewards()
                        updatePrefillHiltonSurpassRewards()
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Button(action: {
                showResetGoldAlert = true
            }) {
                Text("Reset Gold Rewards")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showResetGoldAlert) {
                Alert(
                    title: Text("Reset Gold Rewards"),
                    message: Text("Do you want to reset all Amex Gold rewards? This action cannot be undone."),
                    primaryButton: .destructive(Text("Reset Gold Rewards")) {
                        resetAllRewards()
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Spacer()
        }
        .padding()
    }
    
    private func updatePrefillGoldRewards() -> Void {
        let cardType = "Amex Gold"
        
        let monthlyRewardTemplates = [
            RewardTemplate(title: "Dining Credit", details: "Grubhub, The Cheesecake Factory, Five Guys", value: 10, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Uber Credit", details: "Monthly Uber Cash in-app", value: 10, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Dunkin' Credit", details: "Montly Dunkin' credit", value: 7, year: currentYear, cardType: cardType)
        ]
        
        for template in monthlyRewardTemplates {
            for month in 1...12 {
                let newReward: Reward = createReward(rewardTemplate: template)
                newReward.recurrencePeriod = "month"
                newReward.month = Int16(month)
                newReward.expirationDate = getLastDayOfMonth(year: currentYear, month: month)
            }
        }
        
        let annualRewardTemplates = [
            RewardTemplate(title: "Resy Credit 1/2", details: "Jan - Jun Resy Credit", value: 50, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Resy Credit 2/2", details: "Jul - Dec Resy Credit", value: 50, year: currentYear, cardType: cardType)
        ]
        
        for template in annualRewardTemplates {
            let newReward: Reward = createReward(rewardTemplate: template)
            newReward.recurrencePeriod = "year"
            newReward.expirationDate = getLastDayOfMonth(year: currentYear, month: 12)
            newReward.month = -1
        }
        
        saveContext()
    }
    
    private func updatePrefillPlatinumRewards() -> Void {
        let cardType = "Amex Platinum"
        
        let monthlyRewardTemplates = [
            RewardTemplate(title: "Streaming Credit", details: "Monthly streaming credit", value: 20, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Uber Credit", details: "Monthly Uber Cash in-app", value: 15, year: currentYear, cardType: cardType)
        ]
        
        for template in monthlyRewardTemplates {
            for month in 1...12 {
                let newReward: Reward = createReward(rewardTemplate: template)
                newReward.recurrencePeriod = "month"
                newReward.month = Int16(month)
                newReward.expirationDate = getLastDayOfMonth(year: currentYear, month: month)
            }
        }
        
        let annualRewardTemplates = [
            RewardTemplate(title: "Airline Fee Credit", details: "Airline fee credit on your selected airline", value: 200, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Hotel Credit", details: "Annual FHR / THC hotel credit", value: 200, year: currentYear, cardType: cardType),
            RewardTemplate(title: "CLEAR Plus Credit", details: "Annual CLEAR credit", value: 199, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Saks Credit 1/2", details: "Jan - Jun Saks Credit", value: 50, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Saks Credit 2/2", details: "Jul - Dec Saks Credit", value: 50, year: currentYear, cardType: cardType),
            RewardTemplate(title: "December Uber Bonus", details: "Extra Uber Cash in Dec", value: 20, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Equinox Credit", details: "Annual Equinox credit", value: 300, year: currentYear, cardType: cardType)
        ]
        
        for template in annualRewardTemplates {
            let newReward: Reward = createReward(rewardTemplate: template)
            newReward.recurrencePeriod = "year"
            newReward.expirationDate = getLastDayOfMonth(year: currentYear, month: 12)
            newReward.month = -1
        }
        
        saveContext()
    }
    
    private func updatePrefillDeltaReserveRewards() -> Void {
        let cardType = "Amex Delta Reserve"
        
        let monthlyRewardTemplates = [
            RewardTemplate(title: "Resy Credit", details: "Monthly Resy credit", value: 20, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Rideshare Credit", details: "Monthly Uber / Lyft credit", value: 10, year: currentYear, cardType: cardType)
        ]
        
        for template in monthlyRewardTemplates {
            for month in 1...12 {
                let newReward: Reward = createReward(rewardTemplate: template)
                newReward.recurrencePeriod = "month"
                newReward.month = Int16(month)
                newReward.expirationDate = getLastDayOfMonth(year: currentYear, month: month)
            }
        }
        
        let annualRewardTemplates = [
            RewardTemplate(title: "Delta Club Access", details: "Delta Sky Club Access", value: 0, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Delta Club Guest", details: "Delta Sky Club 4 Guests", value: 100, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Free Delta Bags", details: "Delta Free Checked Baggage", value: 150, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Delta Companion", details: "Annual companion certificate", value: 500, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Delta Stays Credit", details: "Annual Delta Stays credit", value: 200, year: currentYear, cardType: cardType)
        ]
        
        for template in annualRewardTemplates {
            let newReward: Reward = createReward(rewardTemplate: template)
            newReward.recurrencePeriod = "year"
            newReward.expirationDate = getLastDayOfMonth(year: currentYear, month: 12)
            newReward.month = -1
        }
        
        saveContext()
    }
    
    private func updatePrefillDeltaPlatinumRewards() -> Void {
        let cardType = "Amex Delta Platinum"
        
        let monthlyRewardTemplates = [
            RewardTemplate(title: "Resy Credit", details: "Monthly Resy credit", value: 10, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Rideshare Credit", details: "Monthly Uber / Lyft credit", value: 10, year: currentYear, cardType: cardType)
        ]
        
        for template in monthlyRewardTemplates {
            for month in 1...12 {
                let newReward: Reward = createReward(rewardTemplate: template)
                newReward.recurrencePeriod = "month"
                newReward.month = Int16(month)
                newReward.expirationDate = getLastDayOfMonth(year: currentYear, month: month)
            }
        }
        
        let annualRewardTemplates = [
            RewardTemplate(title: "Delta Companion", details: "Annual companion certificate", value: 500, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Delta Stays Credit", details: "Annual Delta Stays credit", value: 150, year: currentYear, cardType: cardType)
        ]
        
        for template in annualRewardTemplates {
            let newReward: Reward = createReward(rewardTemplate: template)
            newReward.recurrencePeriod = "year"
            newReward.expirationDate = getLastDayOfMonth(year: currentYear, month: 12)
            newReward.month = -1
        }
        
        saveContext()
    }
    
    private func updatePrefillDeltaGoldRewards() -> Void {
        let cardType = "Amex Delta Gold"
        
        let annualRewardTemplates = [
            RewardTemplate(title: "Delta Flight Credit", details: "$200 flight credit for $10k spend", value: 200, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Delta Stays Credit", details: "Annual Delta Stays credit", value: 150, year: currentYear, cardType: cardType)
        ]
        
        for template in annualRewardTemplates {
            let newReward: Reward = createReward(rewardTemplate: template)
            newReward.recurrencePeriod = "year"
            newReward.expirationDate = getLastDayOfMonth(year: currentYear, month: 12)
            newReward.month = -1
        }
        
        saveContext()
    }
    
    private func updatePrefillHiltonSurpassRewards() -> Void {
        let cardType = "Amex Delta Gold"
        
        let annualRewardTemplates = [
            RewardTemplate(title: "Hilton Credit Q1", details: "Jan - Mar Hilton credit", value: 50, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Hilton Credit Q2", details: "Apr - Jun Hilton credit", value: 50, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Hilton Credit Q3", details: "Jul - Sep Hilton credit", value: 50, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Hilton Credit Q4", details: "Oct - Dec Hilton credit", value: 50, year: currentYear, cardType: cardType)
        ]
        
        for template in annualRewardTemplates {
            let newReward: Reward = createReward(rewardTemplate: template)
            newReward.recurrencePeriod = "year"
            newReward.expirationDate = getLastDayOfMonth(year: currentYear, month: 12)
            newReward.month = -1
        }
        
        saveContext()
    }
    
    private func updatePrefillHiltonAspireRewards() -> Void {
        let cardType = "Amex Hilton Aspire"
        
        let annualRewardTemplates = [
            RewardTemplate(title: "Diamond Status", details: "Upgraded to Hilton Diamond", value: 0, year: currentYear, cardType: cardType),
            RewardTemplate(title: "CLEAR Credit", details: "CLEAR credit for companion", value: 199, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Free Hilton Night", details: "Free night certificate", value: 200, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Hilton Credit 1/2", details: "Jan - Jun Hilton Credit", value: 200, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Hilton Credit 2/2", details: "Jul - Dec Hilton Credit", value: 200, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Airline Credit Q1", details: "Jan - Mar airline credit", value: 50, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Airline Credit Q2", details: "Apr - Jun airline credit", value: 50, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Airline Credit Q3", details: "Jul - Sep airline credit", value: 50, year: currentYear, cardType: cardType),
            RewardTemplate(title: "Airline Credit Q4", details: "Oct - Dec airline credit", value: 50, year: currentYear, cardType: cardType)
        ]
        
        for template in annualRewardTemplates {
            let newReward: Reward = createReward(rewardTemplate: template)
            newReward.recurrencePeriod = "year"
            newReward.expirationDate = getLastDayOfMonth(year: currentYear, month: 12)
            newReward.month = -1
        }
        
        saveContext()
    }
    
    private func resetAllRewards() {
        let requestGoldRewards = NSFetchRequest<Reward>()
        requestGoldRewards.entity = Reward.entity()
        do {
            let rewardsToDelete: [Reward] = try viewContext.fetch(requestGoldRewards)
            rewardsToDelete.forEach(viewContext.delete)
        }
        catch {
            print("Error in deleting Gold Reward items.")
        }
        
        saveContext()
    }
    
    private func createReward(rewardTemplate: RewardTemplate) -> Reward {
        let newReward = Reward(context: viewContext)
        
        newReward.title = rewardTemplate.title
        newReward.details = rewardTemplate.details
        newReward.value = rewardTemplate.value
        newReward.year = Int16(rewardTemplate.year)
        newReward.cardType = rewardTemplate.cardType
        newReward.redeemed = false
        
        return newReward
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error: \(error)")
        }
    }
    
    private func getLastDayOfMonth(year: Int, month: Int) -> Date? {
        var components = DateComponents()
        components.year = year
        components.month = month

        // Get the range of days in the specified month
        let range = Calendar.current.range(of: .day, in: .month, for: Calendar.current.date(from: components)!)
        
        // The last day of the month is the last element in the range
        guard let lastDay = range?.count else { return nil }
        
        // Create the date for the last day of the month
        components.day = lastDay
        return Calendar.current.date(from: components)
    }
}

struct RewardTemplate {
    var title: String
    var details: String
    var value: Float
    var year: Int
    var cardType: String
}
    
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("") //SettingsView()
    }
}
