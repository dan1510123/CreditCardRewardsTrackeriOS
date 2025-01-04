//
//  AnnualListView.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/13/21.
//

import SwiftUI
import CoreData

struct AnnualListPage: View {
    
    @Binding var adminMode: Bool
    
    @State var index: Int = Calendar.current.component(.year, from: Date())  * 100 + Calendar.current.component(.month, from: Date())
    @Binding var year: Int
    @State var month: Int = -1
    
    let viewContext: NSManagedObjectContext
    let recurrencePeriod: String = "year"
    
    init(viewContext: NSManagedObjectContext, year: Binding<Int>, adminMode: Binding<Bool>) {
        self.viewContext = viewContext
        self._year = year
        self._adminMode = adminMode
    }
    
    var body: some View {
        VStack(alignment: .center) {
            NavigationView {
                ListView(index: index, recurrencePeriod: recurrencePeriod, month: $month, year: $year, adminMode: $adminMode, viewContext: viewContext)
                    .navigationTitle("\(year) Annual Rewards".replacingOccurrences(of: ",", with: ""))
                    .navigationBarItems(
                        leading: getLeadingButton(),
                        trailing: getTrailingButton()
                    )
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            currentYearIndicator
                        }
                    }
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
                        .background(Color(UIColor.systemBackground))
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
            else if year > 2020 {
                Button(action:  {
                    year = year - 1
                })
                {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text(String(year - 1))
                    }
                }
                .frame(alignment: .leading)
            }
        }
    }
    
    private func getTrailingButton() -> some View {
        Group {
            if adminMode {
                NavigationLink("Add Annual Reward", destination: AddRewardPage(recurrencePeriod: recurrencePeriod)).isDetailLink(false)
            }
            else {
                Button(action:  {
                    year = year + 1
                })
                {
                    HStack {
                        Text(String(year + 1))
                        Image(systemName: "chevron.right")
                    }
                }
                .frame(alignment: .trailing)
            }
        }
    }
    
    private var currentYearIndicator: some View {
        Group {
            if year == Calendar.current.component(.year, from: Date()) && !self.adminMode {
                Text("Current")
                    .font(.body)
                    .padding(6)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.blue)
                    )
                    .foregroundColor(.white)
            }
        }
    }
}

struct AnnualListView_Previews: PreviewProvider {
    static var previews: some View {
        Text("")//AnnualListPage(year: 2024, viewContext: PersistenceController.preview.container.viewContext)
    }
}
