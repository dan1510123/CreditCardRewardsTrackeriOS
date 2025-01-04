//
//  LimitedTimeTab.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/13/21.
//

import SwiftUI
import CoreData

struct LimitedTimeTab: View {
    
    @Binding var adminMode: Bool
    
    @State var index: Int = Calendar.current.component(.year, from: Date()) * 10000 + Calendar.current.component(.month, from: Date()) * 100 + Calendar.current.component(.day, from: Date())
    
    @State var year: Int = Calendar.current.component(.year, from: Date())
    @State var month: Int = -1
    
    let viewContext: NSManagedObjectContext
    let recurrencePeriod: String = "once"
    
    init(viewContext: NSManagedObjectContext, adminMode: Binding<Bool>) {
        self.viewContext = viewContext
        self._adminMode = adminMode
    }
    
    var body: some View {
        VStack(alignment: .center) {
            NavigationView {
                ListView(index: index, recurrencePeriod: recurrencePeriod, month: $month, year: $year, adminMode: $adminMode, viewContext: viewContext)
                    .navigationTitle("One-Time Rewards".replacingOccurrences(of: ",", with: ""))
                    .navigationBarItems(
                        leading: getLeadingButton(),
                        trailing: getTrailingButton()
                    )
            }
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
        .background(Color(UIColor.systemBackground))
    }
    
    private func getLeadingButton() -> some View {
        Group {
            if adminMode {
                EditButton()
            }
        }
    }
    
    private func getTrailingButton() -> some View {
        Group {
            if adminMode {
                NavigationLink("Add One-Time Reward", destination: AddRewardPage(viewContext: viewContext, recurrencePeriod: recurrencePeriod)).isDetailLink(false)
            }
        }
    }
}

struct LimitedTimeListView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")//AnnualListPage(year: 2024, viewContext: PersistenceController.preview.container.viewContext)
    }
}
