//
//  SummaryTab.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/14/21.
//

import SwiftUI
import CoreData

struct SummaryTab: View {
    
    @Binding var specialAdminMode: Bool
    
    @State var isSettingsPresented:Bool = false
    
    let viewContext: NSManagedObjectContext
    @Binding var year: Int

    var fetchRequest: FetchRequest<CardType>
    @FetchRequest(entity: CardType.entity(), sortDescriptors: [])
    var cards: FetchedResults<CardType>
    
    var totalFees: Int16 {
        cards.reduce(0) { $0 + $1.annualFee }
    }
    
    init(viewContext: NSManagedObjectContext, year: Binding<Int>, specialAdminMode: Binding<Bool>) {
        self.viewContext = viewContext
        self._specialAdminMode = specialAdminMode
        self._year = year
        
        fetchRequest = FetchRequest<CardType>(entity: CardType.entity(),
            sortDescriptors: [
                NSSortDescriptor(keyPath: \CardType.annualFee, ascending: false)
            ]
        )
    }
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ProgressTileView(annualFee: Float(totalFees), rewardType: "Total",
                                     year: year)
                    ForEach(fetchRequest.wrappedValue) { cardType in
                        ProgressTileView(annualFee: Float(cardType.annualFee),
                                         rewardType: cardType.cardName!,
                                         year: year)
                    }
                    .navigationTitle("\(year) Rewards Summary".replacingOccurrences(of: ",", with: ""))
                    .navigationBarItems(
                        leading: getLeadingButton(),
                        trailing: getTrailingButton()
                    )
                }
                .background(Color.white)
            }
            .sheet(isPresented: $isSettingsPresented) {
                SettingsView(isSettingsPresented: $isSettingsPresented)
            }
            
            if specialAdminMode {
                Button(action: {
                    self.specialAdminMode.toggle()
                }) {
                    Text("LEAVE SPECIAL ADMIN MODE")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 10)
            }
        }
    }
    
    private func getLeadingButton() -> some View {
        Group {
            if specialAdminMode {
                Button(action: {
                    isSettingsPresented = true
                })
                {
                    HStack {
                        Image(systemName: "gearshape.fill")
                        Text("Settings")
                    }
                }
            } else {
                Button(action:  {
                    year = year - 1
                })
                {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text(String(year - 1) + " Summary")
                    }
                }
                .frame(alignment: .leading)
            }
        }
    }
    
    private func getTrailingButton() -> some View {
        Group {
            Button(action:  {
                year = year + 1
            })
            {
                HStack {
                    Text(String(year + 1) + " Summary")
                    Image(systemName: "chevron.right")
                }
            }
            .frame(alignment: .leading)
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        Text("") // SummaryView()
    }
}
