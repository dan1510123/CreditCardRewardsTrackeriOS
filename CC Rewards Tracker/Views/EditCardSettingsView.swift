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
    
    init(viewContext: NSManagedObjectContext, cardName: String, annualFee: String) {
        self.viewContext = viewContext
        self.cardName = cardName
        self.annualFee = annualFee
    }
    var body: some View {
        Form {
            Section(header: Text(annualFee)) {
                TextField("Enter value", text: $annualFee)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
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
        // update
        
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved error: \(error)")
        }
    }
}
    
struct EditCardSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("") //SettingsView()
    }
}
