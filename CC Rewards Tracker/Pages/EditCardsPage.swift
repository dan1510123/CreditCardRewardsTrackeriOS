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
}
    
struct EditCardsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("") //SettingsView()
    }
}
