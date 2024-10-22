//
//  NotificationManager.swift
//  CC Rewards Tracker
//
//  Created by Daniel Luo on 10/22/24.
//

import SwiftUI
import CoreData
import UserNotifications

struct NotificationManager {
    
    static func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    static func testNotification(context: NSManagedObjectContext) {
        let expiringRewards = fetchExpiringRewards(context: context)
        
        // Create the notification content
        let content = UNMutableNotificationContent()
        if expiringRewards.isEmpty {
            content.title = "Rewards are good!"
            content.body = "Great job keeping up with using your rewards! You're all set!"
        } else {
            content.title = "Rewards Expiring Soon!"
            let rewardNames = expiringRewards.map { $0.title! }
            content.body = "The following rewards are expiring soon: \(rewardNames.joined(separator: ", "))."
        }
        content.sound = .default
        
        let tenSecondsLater = Calendar.current.date(byAdding: .second, value: 10, to: Date())
        let trigger = getTrigger(reminderDate: tenSecondsLater!)        
        let request = UNNotificationRequest(identifier: "RewardReminderNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Test notification scheduled!")
            }
            
        }
    }
    
    static func clearScheduledNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    static func fetchExpiringRewards(context: NSManagedObjectContext) -> [Reward] {
        let fetchRequest: NSFetchRequest<Reward> = Reward.fetchRequest()
        
        // Calculate the date range for rewards expiring within the specified days
        let currentDate = Date()
        let endDate = getDaysBeforeEndOfMonth(days: 0)!
        
        // Fetch rewards with expiration dates within the calculated date range
        fetchRequest.predicate = NSPredicate(format: "expirationDate >= %@ AND expirationDate <= %@", currentDate as NSDate, endDate as NSDate)
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch rewards: \(error.localizedDescription)")
            return []
        }
    }
    
    static func getDaysBeforeEndOfMonth(days: Int) -> Date? {
        let calendar = Calendar.current
        
        // Get the start of the next month
        let nextMonth = calendar.date(byAdding: .month, value: 1, to: Date())
        let startOfNextMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: nextMonth!))
        
        return calendar.date(byAdding: .day, value: -1 * days, to: startOfNextMonth!)
    }
    
    static func schedulerReminderNotifications(context: NSManagedObjectContext) {
        scheduleReminderDaysBefore(context: context, daysBefore: 7)
        scheduleReminderDaysBefore(context: context, daysBefore: 14)
    }

    static func scheduleReminderDaysBefore(context: NSManagedObjectContext, daysBefore: Int) {
        let expiringRewards = fetchExpiringRewards(context: context)
        
        // Create the notification content
        let content = UNMutableNotificationContent()
        if expiringRewards.isEmpty {
            content.title = "Rewards are good!"
            content.body = "Great job keeping up with using your rewards! You're all set!"
        } else {
            content.title = "Rewards Expiring Soon!"
            let rewardNames = expiringRewards.map { $0.title! }
            content.body = "The following rewards are expiring soon: \(rewardNames.joined(separator: ", "))."
        }
        content.sound = .default
        
        let trigger = getTrigger(reminderDate: getDaysBeforeEndOfMonth(days: daysBefore)!)
        let request = UNNotificationRequest(identifier: "RewardReminderNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(daysBefore) days before end of month!")
            }
        }
    }
    
    static func getTrigger(reminderDate: Date) -> UNCalendarNotificationTrigger {
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: reminderDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true)
        
        return trigger
    }
    
}
