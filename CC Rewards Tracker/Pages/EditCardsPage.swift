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
        NavigationView {
            List {
                ForEach(fetchRequest.wrappedValue) { card in
                    NavigationLink(
                        destination: UpdateCardTypePage(viewContext: viewContext, cardName: card.cardName!, annualFee: String(card.annualFee), cardColorHexString: card.cardColor!),
                        label: {
                            HStack {
                                Text(card.cardName ?? "Error")
                                    .font(.headline)
                                Spacer()
                                Text(String(card.annualFee))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 10)
                        })
                }
                .onDelete(perform: deleteTasks)
                .background(Color.white)
            }
            .navigationTitle("My Tracked Cards")
            .navigationBarItems(
                trailing: getTrailingButton()
            )
        }
    }
    
    private func getTrailingButton() -> some View {
        Group {
            NavigationLink("Add Card", destination: AddCardPage())
        }
    }
    
    private func deleteTasks(offsets: IndexSet) {
        withAnimation {
            offsets.forEach {
                let cardToDelete: CardType = cards[$0]
                let cardNameToDelete: String = cardToDelete.cardName ?? ""
                let requestCardEntity = NSFetchRequest<CardType>()
                requestCardEntity.entity = CardType.entity()
                requestCardEntity.predicate = NSPredicate(format: "cardName == \"\(cardNameToDelete)\"")
                do {
                    let cardToDelete: [CardType] = try viewContext.fetch(requestCardEntity)
                    cardToDelete.forEach(viewContext.delete)
                }
                catch {
                    print("Error in deleting items: \($0)")
                }
            }
            saveContext()
        }
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
