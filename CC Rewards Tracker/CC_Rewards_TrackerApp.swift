//
//  CC_Rewards_TrackerApp.swift
//  Credit Card Rewards Tracker
//
//  Created by Daniel Luo on 6/11/21.
//

import SwiftUI

@main
struct CC_Rewards_TrackerApp: App {
    
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            FullTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    // Request notification permission and schedule the notification
                    NotificationManager.requestNotificationPermission()
                    NotificationManager.clearScheduledNotifications()
                    NotificationManager.schedulerReminderNotifications(
                        context: persistenceController.container.viewContext
                    )
                }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active || newPhase == .background {
                // Reschedule whenever the app is opened
                NotificationManager.clearScheduledNotifications()
                NotificationManager.schedulerReminderNotifications(
                    context: persistenceController.container.viewContext
                )
            }
        }
    }
}
