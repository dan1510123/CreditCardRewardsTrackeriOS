//
//  SummaryTab.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/14/21.
//

import SwiftUI
import CoreData

struct SummaryTab: View {
    
    @Binding var adminMode: Bool
    
    @State var isSettingsPresented:Bool = false
    
    let viewContext: NSManagedObjectContext
    @Binding var year: Int

    var fetchRequest: FetchRequest<CardType>
    @FetchRequest(entity: CardType.entity(), sortDescriptors: [])
    var cards: FetchedResults<CardType>
    
    var totalFees: Int16 {
        cards.reduce(0) { $0 + $1.annualFee }
    }
    
    init(viewContext: NSManagedObjectContext, year: Binding<Int>, adminMode: Binding<Bool>) {
        self.viewContext = viewContext
        self._year = year
        self._adminMode = adminMode
        
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
                        //                    ProgressTileView(annualFee: 695, rewardType: "Platinum",
                        //                                     year: year)
                        //                    ProgressTileView(annualFee: 325, rewardType: "Gold",
                        //                                     year: year)
                        //                    ProgressTileView(annualFee: 550, rewardType: "Hilton Aspire",
                        //                                     year: year)
                        //                    ProgressTileView(annualFee: 650, rewardType: "Delta Reserve",
                        //                                     year: year)
                        //                    ProgressTileView(annualFee: 150, rewardType: "Delta Gold",
                        //                                     year: year)
                        
                    }
                    .navigationTitle("\(year) Rewards Summary".replacingOccurrences(of: ",", with: ""))
                    .navigationBarItems(
                        leading: getLeadingButton(),
                        trailing: getTrailingButton()
                    )
                }
                .background(Color.white)
                
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
            }
            .sheet(isPresented: $isSettingsPresented) {
                SettingsView(isSettingsPresented: $isSettingsPresented)
            }
        }
    }
    
    private func getLeadingButton() -> some View {
        Group {
            if adminMode {
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
