//
//  AddRewardPage.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/11/21.
//

import SwiftUI
import CoreData

struct UpdateRewardPage: View {
    @Environment(\.presentationMode) private var presentationMode
    let viewContext: NSManagedObjectContext
    
    let oldRewardTitle: String
    
    @State private var showInvalidAlert: Bool = false
    @State private var isDatePickerPresented: Bool = false
    
    @State private var title: String
    @State private var details: String
    @State private var month: String
    @State private var year: String
    @State private var cardType: String
    @State private var value: String
    @State private var recurrencePeriod: String
    @State private var expirationDate: Date
    
    var cardFetchRequest: FetchRequest<CardType>
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
        
    init(viewContext: NSManagedObjectContext, reward: Reward) {
        self.viewContext = viewContext
        self.oldRewardTitle = reward.title!
        
        self.title = reward.title!
        self.details = reward.details!
        self.month = String(reward.month)
        self.year =  String(reward.year)
        self.cardType = reward.cardType!
        self.value = String(reward.value)
        self.recurrencePeriod = reward.recurrencePeriod!
        self.expirationDate = reward.expirationDate!
        
        self.cardFetchRequest = FetchRequest<CardType>(entity: CardType.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \CardType.annualFee, ascending: false)
            ]
        )
    }
    
    var body: some View {
        ScrollView {
            Text("Update \(recurrencePeriod) Reward ⭐️")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .frame(maxWidth: 200, maxHeight: 50)
                .font(.title)
            VStack {
                TextField("Reward Title", text: $title)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                    .cornerRadius(10)
                
                TextField("Reward Details / Description", text: $details)
                    .padding(.horizontal)
                    .frame(height: 120)
                    .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                    .cornerRadius(10)
                
                if(self.recurrencePeriod == "year" || self.recurrencePeriod == "month") {
                    Picker("Year", selection: $year) {
                        Text(String(year))
                            .tag(year)
                    }
                }
                else if recurrencePeriod == "once"  {
                    Button(action: {
                        isDatePickerPresented.toggle()
                    }) {
                        Text(formattedDate(expirationDate))
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $isDatePickerPresented) {
                        // DatePicker in a sheet
                        VStack {
                            DatePicker("Select a date", selection: Binding(
                                get: { expirationDate },
                                set: { expirationDate = $0 }
                            ), displayedComponents: [.date])
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding()
                            
                            Button("Done") {
                                isDatePickerPresented = false
                            }
                            .padding()
                        }
                        .padding()
                    }
                }
                
                VStack {
                    if !cardFetchRequest.wrappedValue.isEmpty {
                        Picker("Card", selection: $cardType) {
                            ForEach(cardFetchRequest.wrappedValue, id: \.self) { card in
                                Text(card.cardName ?? "")
                                    .tag(card.cardName ?? "")
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    } else {
                        Text("No cards available")
                            .foregroundColor(.gray)
                    }
                }
                .padding()

                TextField("Reward \(recurrencePeriod) Value", text: $value)
                    .keyboardType(.numberPad)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                
                Button(action: updateReward, label: {
                    Text("Save".uppercased())
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                })
            }
            .padding(16)
        }
        .alert(isPresented: $showInvalidAlert) {
            Alert(
                title: Text("Invalid Selection"),
                message: Text("You cannot select 'None' as a card type."),
                dismissButton: .default(Text("OK"))
            )
        }
        
    }
    
    private func updateReward() {
        let requestRewardEntity = NSFetchRequest<Reward>(entityName: "Reward")
        requestRewardEntity.predicate = NSPredicate(format: "title == %@ and year == %@", oldRewardTitle, year)
        
        do {
            let rewardsToUpdate: [Reward] = try viewContext.fetch(requestRewardEntity)
            
            for rewardToUpdate in rewardsToUpdate {
                rewardToUpdate.title = self.title
                rewardToUpdate.details = self.details
                rewardToUpdate.cardType = self.cardType
                rewardToUpdate.value = Float(self.value) ?? 0
                
                if recurrencePeriod == "once" {
                    rewardToUpdate.expirationDate = self.expirationDate
                }
            }
            
            try viewContext.save()
            print("Card updated successfully.")
        } catch {
            print("Error updating card: \(error.localizedDescription)")
        }
        
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
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

struct EditRewardPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            //AddRewardPage(recurrencePeriod: "One-Time")
        }
    }
}
