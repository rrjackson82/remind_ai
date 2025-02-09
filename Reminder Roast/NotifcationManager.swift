//
//  NotifcationManager.swift
//  Reminder Roast
//
//  Created by Dane Ohr on 2/9/25.
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func scheduleNotification(title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(date)")
            }
        }
    }
    // New function to cancel a notification
    func cancelNotification(for taskId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskId.uuidString])
        print("Notification canceled for task: \(taskId)")
    }
}
