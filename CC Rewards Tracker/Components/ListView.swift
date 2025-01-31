//
//  ListView.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/11/21.
//

import SwiftUI
import CoreData

struct ListView: View {
    
    let viewContext: NSManagedObjectContext
    var adminMode: Binding<Bool>
    
    let index: Int
    let recurrencePeriod: String
    let month: Int
    let year: Int
    
    var managedObjectContext: NSManagedObjectContext!
    var fetchRequest: FetchRequest<Reward>
    var rewards: FetchedResults<Reward> { fetchRequest.wrappedValue }
    
    init(index: Int, recurrencePeriod: String, month: Binding<Int>, year: Binding<Int>, adminMode: Binding<Bool>, viewContext: NSManagedObjectContext) {
        fetchRequest = FetchRequest<Reward>(entity: Reward.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \Reward.redeemed, ascending: true),
                NSSortDescriptor(keyPath: \Reward.expirationDate, ascending: true),
                NSSortDescriptor(keyPath: \Reward.value, ascending: false),
                NSSortDescriptor(keyPath: \Reward.title, ascending: true)
            ],
            
            predicate: NSPredicate(format: "recurrencePeriod == \"\(recurrencePeriod)\" and month == \(month.wrappedValue) and year == \(year.wrappedValue)")
        )
        
        self.index = index
        self.recurrencePeriod = recurrencePeriod
        self.month = month.wrappedValue
        self.year = year.wrappedValue
        self.adminMode = adminMode
        self.viewContext = viewContext
    }
    
    var body: some View {
        if adminMode.wrappedValue {
            List {
                ForEach(fetchRequest.wrappedValue) { reward in
                    ListRowView(reward: reward, title: reward.title ?? "Untitled", details: reward.details ?? "", value: reward.value, redeemed: reward.redeemed, adminMode: true)
                }
                .onDelete(perform: deleteTasks)
            }
        } else {
            List {
                ForEach(fetchRequest.wrappedValue) { reward in
                    ListRowView(reward: reward, title: reward.title ?? "Untitled", details: reward.details ?? "", value: reward.value, redeemed: reward.redeemed)
                }
            }
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
    
    private func deleteTasks(offsets: IndexSet) {
        if(adminMode.wrappedValue) {
            withAnimation {
                offsets.forEach {
                    let rewardToDelete: Reward = rewards[$0]
                    let titleToDelete: String = rewardToDelete.title ?? ""
                    let requestFullYear = NSFetchRequest<Reward>()
                    requestFullYear.entity = Reward.entity()
                    requestFullYear.predicate = NSPredicate(format: "recurrencePeriod == \"\(recurrencePeriod)\" and title == \"\(titleToDelete)\" and year == \(year)")
                    do {
                        let rewardsToDelete: [Reward] = try viewContext.fetch(requestFullYear)
                        rewardsToDelete.forEach(viewContext.delete)
                    }
                    catch {
                        print("Error in deleting items: \($0)")
                    }
                }
                saveContext()
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
        }
    }
}
