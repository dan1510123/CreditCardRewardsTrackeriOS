//
//  SettingsTab.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/14/21.
//

import SwiftUI
import CoreData

struct SettingsTab: View {
    
    @Binding var adminMode: Bool
    
    @State var updateTrackedCards: Bool = false
    
    let viewContext: NSManagedObjectContext
    @State var year: Int = Calendar.current.component(.year, from: Date())
    
    init(viewContext: NSManagedObjectContext, adminMode: Binding<Bool>) {
        self.viewContext = viewContext
        self._adminMode = adminMode
    }
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    Text("Settings")
                        .font(.largeTitle)
                        .padding()
                    
                    NavigationLink(
                        destination: EditCardsPage(viewContext: viewContext),
                        label: {
                            Text("Edit Tracked Cards")
                        })
                }
                .background(Color.white)
            }
        }
    }
}




struct SettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        Text("") // SummaryView()
    }
}
