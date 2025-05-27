//
//  AddCardPage.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/11/21.
//

import SwiftUI

struct AddCardPage: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    let currentYear: Int = 2025
    @State var cardNameFieldText: String = ""
    @State var annualFeeValue: Int16 = 0
    @State var annualFeeFieldText: String = "0"
    @State var iconName: String = "creditCardIcon"
    @State var selectedColor: Color = Color.gray
    
    let presets = CardTypePresets().getPresets()
    
    let defaultPreset: CardTypePreset = CardTypePreset(
        name: "Choose a Card Preset",
        annualFee: 0,
        iconName: "creditCardIcon",
        color: Color.white
    )
    
    @State var selectedPreset: CardTypePreset
    
    init() {
        selectedPreset = defaultPreset
    }
    
    var body: some View {
        VStack {
            Text("Add Credit Card 💳")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .frame(maxWidth: 250, maxHeight: 50)
                .font(.title)
            
            Picker("Card Presets", selection: $selectedPreset) {
                Text("Choose a Card Preset")
                    .tag(defaultPreset)
                ForEach(presets, id: \.self) { preset in
                    Text(preset.name)
                        .tag(preset)
                }
            }
            .onChange(of: selectedPreset) { newPresetSelection in
                self.cardNameFieldText = newPresetSelection.name
                self.annualFeeValue = Int16(newPresetSelection.annualFee)
                self.annualFeeFieldText = String(newPresetSelection.annualFee)
                self.iconName = newPresetSelection.iconName
                self.selectedColor = newPresetSelection.color
            }
            .pickerStyle(MenuPickerStyle())
            
            Form {
                Section(header: Text("Card Name")) {
                    TextField("Card Name", text: $cardNameFieldText)
                        .padding(.horizontal)
                        .frame(height: 55)
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                }
                
                Section(header: Text("Card Annual Fee")) {
                    TextField("Card Annual Fee", text: $annualFeeFieldText)
                        .keyboardType(.numberPad)
                        .padding(.horizontal)
                        .frame(height: 55)
                        .cornerRadius(10)
                        .multilineTextAlignment(.center)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: annualFeeFieldText) { newValue in
                            if let intValue = Int16(newValue) {
                                self.annualFeeValue = intValue
                            } else {
                                self.annualFeeFieldText = "\(self.annualFeeValue)"
                            }
                        }
                }
                
                Section(header: Text("Card Color Representation").font(.caption).foregroundColor(.gray)) {
                    ColorPicker("Select Card Color", selection: $selectedColor)
                        .padding()
                }
                
                Button(action: onSavePressed, label: {
                    Text("Save".uppercased())
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                })
            }
            .background(Color(UIColor.systemGroupedBackground))
            .scrollContentBackground(.hidden)
            .padding(16)
        }
        .background(Color(UIColor.systemGroupedBackground))
    }
    
    private func onSavePressed() {
        let newCardType = CardType(context: viewContext)
        newCardType.cardName = cardNameFieldText
        newCardType.annualFee = annualFeeValue
        newCardType.cardColor = selectedColor.toHex(includeAlpha: true)
        
        switch cardNameFieldText {
        case "Amex Gold":
            updatePrefillGoldRewards()
        case "Amex Platinum":
            updatePrefillPlatinumRewards()
        case "Amex Delta Gold":
            updatePrefillDeltaGoldRewards()
        case "Amex Delta Platinum":
            updatePrefillDeltaPlatinumRewards()
        case "Amex Delta Reserve":
            updatePrefillDeltaReserveRewards()
        case "Amex Hilton Aspire":
            updatePrefillHiltonAspireRewards()
        case "Amex Hilton Surpass":
            updatePrefillHiltonSurpassRewards()
        default:
            break
        }
        
        saveContext()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error: \(error)")
        }
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

struct AddCardPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // AddRewardPage(recurrencePeriod: "One-Time")
        }
    }
}
