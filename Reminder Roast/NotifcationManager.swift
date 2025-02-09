//
//  NotifcationManager.swift
//  Reminder Roast
//
//  Created by Dane Ohr on 2/9/25.
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()

    func scheduleNotification(title: String, body: String, date: Date, id: UUID) {
        let content = UNMutableNotificationContent()
        content.title = "Due date for task " + title
        content.body = body
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date),
            repeats: false
        )

        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for task: \(title) at \(date)")
            }
        }
    }
    func cancelNotification(for taskId: UUID) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [taskId.uuidString])
        print("Notification canceled for task ID: \(taskId)")
    }
}
