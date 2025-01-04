//
//  TabView.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/11/21.
//

import SwiftUI

struct FullTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var isDeviceShaken: Bool = false
    @State private var showAdminAlert: Bool = false
    @State private var adminMode: Bool = false
    
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    let currentMonth: Int = Calendar.current.component(.month, from: Date())
    
    // Custom colors
    private let selectedTabColor = Color.blue
    private let unselectedTabColor = Color.gray.opacity(0.8)
    
    var body: some View {
        ZStack {
            // Background
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            TabView {
                LazyView(SummaryPage(viewContext: viewContext, year: $selectedYear, adminMode: $adminMode))
                    .tabItem {
                        VStack {
                            Image(systemName: "list.bullet.rectangle")
                                .font(.system(size: 22))
                            Text("Summary")
                        }
                    }
                
                LazyView(AnnualListPage(viewContext: viewContext, year: $selectedYear, adminMode: $adminMode))
                    .tabItem {
                        VStack {
                            Image(systemName: "calendar.circle")
                                .font(.system(size: 22))
                            Text("Annual")
                        }
                    }
                
                LazyView(MonthlyListPage(year: $selectedYear, month: currentMonth, viewContext: viewContext, adminMode: $adminMode))
                    .tabItem {
                        VStack {
                            Image(systemName: "calendar")
                                .font(.system(size: 22))
                            Text("Monthly")
                        }
                    }
                
                LazyView(LimitedTimeListPage(viewContext: viewContext, adminMode: $adminMode))
                    .tabItem {
                        VStack {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 22))
                            Text("Limited Time")
                        }
                    }
                
                LazyView(SettingsPage(viewContext: viewContext, adminMode: $adminMode))
                    .tabItem {
                        VStack {
                            Image(systemName: "gear")
                                .font(.system(size: 22))
                            Text("Settings")
                        }
                    }
            }
            .accentColor(selectedTabColor)
            .onAppear {
                UITabBar.appearance().backgroundColor = UIColor.systemGray6
                UITabBar.appearance().isTranslucent = true
                UITabBar.appearance().shadowImage = UIImage()
                UITabBar.appearance().backgroundImage = UIImage()
            }
        }
        .alert(isPresented: $showAdminAlert) {
            Alert(
                title: Text("Admin Mode"),
                message: Text("Would you like to switch to Admin Mode?"),
                primaryButton: .default(Text("Yes")) {
                    adminMode = true
                    showAdminAlert = false
                },
                secondaryButton: .cancel(Text("No")) {
                    adminMode = false
                    showAdminAlert = false
                }
            )
        }
        .onAppear {
            // Register for shake motion notifications
            NotificationCenter.default.addObserver(
                forName: .deviceDidShakeNotification,
                object: nil,
                queue: .main
            ) { _ in
                isDeviceShaken = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    isDeviceShaken = false
                }
            }
        }
        .gesture(
            TapGesture(count: 2)
                .onEnded {
                    if isDeviceShaken {
                        showAdminAlert = true
                        isDeviceShaken = false
                    }
                }
        )
    }
}
    
struct FullTabView_Previews: PreviewProvider {
    static var previews: some View {
        FullTabView()
    }
}
