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
                    
                    if adminMode {
                        Button(action: {
                            self.adminMode.toggle()
                        }) {
                            Text("LEAVE ADMIN MODE")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(#colorLiteral(red: 0.9386306405, green: 0, blue: 0, alpha: 1)))
                                .clipShape(Capsule())
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 10)
                    }
                    else {
                        Button(action: {
                            self.adminMode.toggle()
                        }) {
                            Text("Enter Admin Mode")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(#colorLiteral(red: 0, green: 0.7854827046, blue: 1, alpha: 1)))
                                .clipShape(Capsule())
                        }
                        .padding(.horizontal, 40)
                        .padding(.bottom, 10)
                    }
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
