import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/daneohr/Downloads/Xcode Projects/Reminder Roast/Reminder Roast/Reminder Roast/NotifcationManager.swift", line: 1)
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
        let selectedType = UserDefaults.standard.integer(forKey: __designTimeString("#10426_0", fallback: "notificationType"))
        let notificationBody = newNotificationBody(for: selectedType)
        let content = UNMutableNotificationContent()
        content.title = __designTimeString("#10426_1", fallback: "Due date for task ") + title
        content.body = body
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date),
            repeats: __designTimeBoolean("#10426_2", fallback: false)
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
        let setOne = [__designTimeString("#10426_3", fallback: "Stay focused! Future you will thank you. 😊"), __designTimeString("#10426_4", fallback: "You're doing amazing! Just one more task!"), __designTimeString("#10426_5", fallback: "Progress over perfection-just start!")]
        let setTwo = [__designTimeString("#10426_6", fallback: "Still waiting for the right moment? Now is good."), __designTimeString("#10426_7", fallback: "You're better than this!"), __designTimeString("#10426_8", fallback: "Less procrastinating. More doing.")]
        let setThree = [__designTimeString("#10426_9", fallback: "Even your past self is disappointed. Get to it."), __designTimeString("#10426_10", fallback: "Wow, still not done??"), __designTimeString("#10426_11", fallback: "You had time for this notification, but not for this?"), __designTimeString("#10426_12", fallback: "Get to work or just admit defeat.")]
        let quotes = [setOne, setTwo, setThree]
        guard setType >= __designTimeInteger("#10426_13", fallback: 0), setType < quotes.count else {return __designTimeString("#10426_14", fallback: "Invalid Category. Just get it done!")}
        return quotes[setType].randomElement() ?? __designTimeString("#10426_15", fallback: "Keep Going!")
        
    }
}
