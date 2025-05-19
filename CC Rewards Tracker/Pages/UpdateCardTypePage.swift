//
//  EditCardTypePage.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/11/21.
//

import SwiftUI
import CoreData

struct UpdateCardTypePage: View {
    @Environment(\.presentationMode) private var presentationMode
    let viewContext: NSManagedObjectContext
    
    let cardName: String
    @State private var annualFee: String
    @State private var cardColor: Color = .gray

    
    init(viewContext: NSManagedObjectContext, cardName: String, annualFee: String, cardColorHexString: String) {
        self.viewContext = viewContext
        self.cardName = cardName
        self.annualFee = annualFee
        self.cardColor = Color(hex: cardColorHexString)!
    }
    var body: some View {
        Form {
            Section(header: Text("Annual Fee")) {
                TextField("Enter value", text: $annualFee)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Section(header: Text("Card Color Representation").font(.caption).foregroundColor(.gray)) {
                ColorPicker("Select Card Color", selection: $cardColor)
                    .padding()
            }
            
            
            Button(action: updateCardSetting, label: {
                Text("Save".uppercased())
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .background(Color.accentColor)
                    .cornerRadius(10)
            })
            .foregroundColor(.blue)
        }
        .navigationTitle("Edit \(cardName)")
    }
    
    private func updateCardSetting() -> Void {
        let requestCardEntity = NSFetchRequest<CardType>(entityName: "CardType")
        requestCardEntity.predicate = NSPredicate(format: "cardName == %@", cardName)
        do {
            let cardsToEdit = try viewContext.fetch(requestCardEntity)

            for card in cardsToEdit {
                card.cardName = cardName
                card.annualFee = Int16(annualFee) ?? 0
                card.cardColor = cardColor.toHex()
            }

            try viewContext.save()
            print("Card updated successfully.")
        } catch {
            print("Error updating card: \(error.localizedDescription)")
        }
        
        self.presentationMode.wrappedValue.dismiss()
    }
}
    
struct EditCardSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("") //SettingsView()
    }
}
