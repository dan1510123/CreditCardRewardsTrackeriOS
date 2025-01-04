//
//  AddMRView.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/11/21.
//

import SwiftUI

struct AddCardPage: View {
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var cardNameFieldText: String = ""
    @State var annualFeeFieldText: String = ""
    @State var selectedColor: Color = Color.gray
    
    var body: some View {
        VStack {
            Text("Add Credit Card 💳")
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .frame(maxWidth: 250, maxHeight: 50)
                .font(.title)
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
        newCardType.annualFee = Int16(annualFeeFieldText) ?? 0
        newCardType.cardColor = colorToData(selectedColor)
        
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

struct AddCardPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddRewardPage(recurrencePeriod: "One-Time")
        }
    }
}
