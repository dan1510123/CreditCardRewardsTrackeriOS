//
//  TabView.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/11/21.
//

import SwiftUI
import CoreData

struct EditCardSettingsView: View {
    
    let viewContext: NSManagedObjectContext
    
    let cardName: String
    @State private var annualFee: String
    @State var cardColor: Color = .gray

    
    init(viewContext: NSManagedObjectContext, cardName: String, annualFee: String, cardColorData: Data) {
        self.viewContext = viewContext
        self.cardName = cardName
        self.annualFee = annualFee
        self.cardColor = dataToColor(cardColorData)
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
            
            Button("Save Changes") {
                print("Changes saved for \(cardName): \(annualFee)")
                updateCardSetting()
            }
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
                card.cardColor = colorToData(cardColor)
            }

            try viewContext.save()
            print("Card updated successfully.")
        } catch {
            print("Error updating card: \(error.localizedDescription)")
        }
    }
    
    func colorToData(_ color: Color) -> Data? {
        let uiColor = UIColor(color)
        return try? NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false)
    }
    
    func dataToColor(_ data: Data) -> Color {
        if let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) {
            return Color(uiColor)
        }
        return .gray
    }
}
    
struct EditCardSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("") //SettingsView()
    }
}
