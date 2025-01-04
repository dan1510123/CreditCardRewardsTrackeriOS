//
//  AddRewardPage.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/11/21.
//

import SwiftUI

struct AddRewardPage: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isDatePickerPresented: Bool = false
    @State private var selectedDate: Date? = nil
    
    @State var titleFieldText: String = ""
    @State var detailsFieldText: String = ""
    @State var selectedYear: Int = 2025
    @State var cardType: String = "Gold"
    @State var valueFieldText: String = ""
    
    let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            return formatter
        }()
    
    let recurrencePeriod: String
    
    var body: some View {
        ScrollView {
            Text("Add \(recurrencePeriod) Reward ⭐️")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .frame(maxWidth: 200, maxHeight: 50)
                .font(.title)
            VStack {
                TextField("Reward Title", text: $titleFieldText)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                    .cornerRadius(10)
                
                TextField("Reward Details / Description", text: $detailsFieldText)
                    .padding(.horizontal)
                    .frame(height: 120)
                    .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                    .cornerRadius(10)
                
                if(self.recurrencePeriod == "year" || self.recurrencePeriod == "month") {
                    Picker("Year", selection: $selectedYear) {
                        ForEach([2022, 2023, 2024, 2025, 2026], id: \.self) {
                            Text(String($0))
                        }
                    }
                }
                else if recurrencePeriod == "once"  {
                    Button(action: {
                        isDatePickerPresented.toggle()
                    }) {
                        Text(selectedDate != nil ? formattedDate(selectedDate!) : "Select a Date")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .sheet(isPresented: $isDatePickerPresented) {
                        // DatePicker in a sheet
                        VStack {
                            DatePicker("Select a date", selection: Binding(
                                get: { selectedDate ?? Date() },
                                set: { selectedDate = $0 }
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
                
                Picker("Card", selection: $cardType) {
                    ForEach(["Gold", "Platinum", "Delta Gold", "Delta Reserve"], id: \.self) {
                        Text($0)
                    }
                }

                TextField("Reward \(recurrencePeriod) Value", text: $valueFieldText)
                    .keyboardType(.numberPad)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)))
                    .cornerRadius(10)
                    .multilineTextAlignment(.center)
                
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
            .padding(16)
        }
        
    }
    
    private func onSavePressed() {
        if recurrencePeriod == "year" {
            let newReward: Reward = createReward()
            newReward.recurrencePeriod = "year"
            newReward.expirationDate = getLastDayOfMonth(year: selectedYear, month: 12)
            newReward.month = -1
        }
        else if recurrencePeriod == "month" {
            for month in 1...12 {
                let newReward: Reward = createReward()
                newReward.recurrencePeriod = "month"
                newReward.month = Int16(month)
                newReward.expirationDate = getLastDayOfMonth(year: selectedYear, month: month)
            }
        }
        else if recurrencePeriod == "once" {
            let newReward: Reward = createReward()
            newReward.recurrencePeriod = "once"
            newReward.expirationDate = selectedDate
            newReward.year = Int16(Calendar.current.component(.year, from: Date()))
            newReward.month = -1
        }
        
        saveContext()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func createReward() -> Reward {
        let newReward = Reward(context: viewContext)
        newReward.title = titleFieldText
        newReward.details = detailsFieldText
        newReward.value = Float(valueFieldText) ?? -1
        newReward.year = Int16(selectedYear)
        newReward.cardType = cardType
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

struct AddRewardView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddRewardPage(recurrencePeriod: "One-Time")
        }
    }
}
