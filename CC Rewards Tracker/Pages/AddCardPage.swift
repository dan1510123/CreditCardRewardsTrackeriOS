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
}

struct AddCardPage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            // AddRewardPage(recurrencePeriod: "One-Time")
        }
    }
}
