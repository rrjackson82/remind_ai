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
        content.body = newNotificationBody(for: 0)
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
    
    func newNotificationBody(for setType: Int) -> String {
        let setOne = ["Stay focused! Future you will thank you. 😊", "You're doing amazing! Just one more task!", "Progress over perfection-just start!"]
        let setTwo = ["Still waiting for the right moment? Now is good.", "You're better than this!", "Less procrastinating. More doing."]
        let setThree = ["Even your past self is disappointed. Get to it.", "Wow, still not done??", "You had time for this notification, but not for this?", "Get to work or just admit defeat."]
        let quotes = [setOne, setTwo, setThree]
        guard setType >= 0, setType < quotes.count else {return "Invalid Category. Just get it done!"}
        return quotes[setType].randomElement() ?? "Keep Going!"
        
    }
}
