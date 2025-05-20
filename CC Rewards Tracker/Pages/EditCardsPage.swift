//
//  EditCardsPage.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/11/21.
//

import SwiftUI
import CoreData

struct EditCardsPage: View {
    
    let viewContext: NSManagedObjectContext
    
    var fetchRequest: FetchRequest<CardType>
    var cards: FetchedResults<CardType> { fetchRequest.wrappedValue }
    
    init(viewContext: NSManagedObjectContext) {
        self.viewContext = viewContext
        
        fetchRequest = FetchRequest<CardType>(entity: CardType.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \CardType.annualFee, ascending: false)
            ]
        )
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(fetchRequest.wrappedValue) { card in
                        let cardColorHex = card.cardColor!
                        let cardColor = Color(hex: cardColorHex) ?? Color.gray
                        NavigationLink(
                            destination: UpdateCardTypePage(
                                viewContext: viewContext,
                                cardName: card.cardName ?? "",
                                annualFee: String(card.annualFee),
                                cardColorHexString: card.cardColor ?? "#FFFFFF"
                            )
                        ) {
                            VStack(alignment: .leading) {
                                HStack {
                                    getCardIcon(card: card).resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 40)
                                        .cornerRadius(3)
                                    
                                    Text(card.cardName ?? "Error")
                                        .font(.headline)
                                        .foregroundColor(.primary)

                                    Spacer()

                                    Text("$\(String(card.annualFee))")
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(cardColor)
                                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                            )
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                deleteTasks(card)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
                .navigationTitle("My Tracked Cards")
                .navigationBarItems(
                    trailing: getTrailingButton()
                )
                .padding()
            }
        }
    }
    
    private func getTrailingButton() -> some View {
        Group {
            NavigationLink("Add Card", destination: AddCardPage())
        }
    }
    
    private func deleteTasks(_ cardToDelete: CardType) {
        viewContext.delete(cardToDelete)
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
    
    private func getCardIcon(card: CardType) -> Image {
        if (card.cardName == "Amex Gold") {
            return Image("amexGoldCardIcon")
        }
        else if (card.cardName == "Amex Platinum") {
            return Image("amexPlatinumCardIcon")
        }
        else if (card.cardName == "Amex Delta Gold") {
            return Image("amexDeltaGoldCardIcon")
        }
        else if (card.cardName == "Amex Delta Reserve") {
            return Image("amexDeltaReserveCardIcon")
        }
        else if (card.cardName == "Amex Hilton Aspire") {
            return Image("amexHiltonAspireCardIcon")
        }
        else{
            return Image("creditCardIcon")
        }
    }
}
    
struct EditCardsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("") //SettingsView()
    }
}
