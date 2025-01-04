//
//  MonthlyTab.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/12/21.
//

import SwiftUI
import CoreData

struct MonthlyTab: View {
    
    @State var month: Int = 1
    @Binding var year: Int
    @Binding var adminMode: Bool
    
    let viewContext: NSManagedObjectContext
    let index: Int
    let recurrencePeriod: String = "month"
    
    let monthNames: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    init(year: Binding<Int>, month: Int, viewContext: NSManagedObjectContext, adminMode: Binding<Bool>) {
        self._year = year
        self.month = month
        self.index = year.wrappedValue * 100 + month
        self.viewContext = viewContext
        self._adminMode = adminMode
    }
    
    var body: some View {
        VStack(alignment: .center) {
            NavigationView {
                ListView(index: index, recurrencePeriod: recurrencePeriod, month: $month, year: $year, adminMode: $adminMode, viewContext: viewContext)
                    .navigationTitle(getMonthYearString())
                    .foregroundColor(.primary)
                    .navigationBarItems(
                        leading: getLeadingButton(),
                        trailing: getTrailingButton()
                    )
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            currentMonthIndicator
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
                        .frame(alignment: .leading)
            } else {
                if month != 1 {
                    Button(action:  {
                        year = year + (Int)((month + 10) / 12 - 1)
                        month = (month + 10) % 12 + 1
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text(monthNames[month - 2])
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.accentColor)
    }
    
    private func getTrailingButton() -> some View {
        Group {
            if adminMode {
                NavigationLink("Add Monthly Reward", destination: AddRewardPage(viewContext: viewContext, recurrencePeriod: recurrencePeriod))
            } else if month != 12 {
                Button(action:  {
                    year = year + (Int)(month / 12)
                    month = month + 1
                }){
                    HStack {
                        Text(monthNames[month])
                        Image(systemName: "chevron.right")
                    }
                }
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .foregroundColor(.accentColor)
    }
    
    private func getMonthYearString() -> String {
        // Use a separate variable to get the month name
        let monthName = (month >= 1 && month <= 12) ? monthNames[month - 1] : "Invalid Month"
        
        return "\(monthName) \(year) Rewards"
    }
    
    private var currentMonthIndicator: some View {
        Group {
            if year == Calendar.current.component(.year, from: Date()) && month == Calendar.current.component(.month, from: Date()) && !self.adminMode {
                Text("Current")
                    .font(.body)
                    .padding(6) // Add padding around the text
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.blue) // Background color of the rounded rectangle
                    )
                    .foregroundColor(.white) // Text color
            }
        }
    }
}

struct MonthlyListPage_Previews: PreviewProvider {
    static var previews: some View {
        Text("")//MonthlyListPage(year: 2024, month: 10, viewContext: PersistenceController.preview.container.viewContext)
    }
}
