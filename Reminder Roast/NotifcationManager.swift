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
        let selectedType = UserDefaults.standard.integer(forKey: "notificationType")
        let notificationBody = newNotificationBody(for: selectedType)
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = notificationBody
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
    
    var lastNotification: String? = nil
    
    func newNotificationBody(for setType: Int) -> String {
        let setOne = ["Stay focused! Future you will thank you. 😊", "You're doing amazing! Just one more task!", "Progress over perfection-just start!"]
        let setTwo = ["Still waiting for the right moment? Now is good.", "You're better than this!", "Less procrastinating. More doing."]
        let setThree = ["Even your past self is disappointed. Get to it.", "Wow, still not done??", "You had time for this notification, but not for this?", "Get to work or just admit defeat."]
        let quotes = [setOne, setTwo, setThree]
        guard setType >= 0, setType < quotes.count else {return "Invalid Category. Just get it done!"}
//        let chosen = quotes[setType].randomElement() ?? "Keep Going!"
//        let available = quotes[setType].filter { $0 != chosen}
        var availableQuotes = quotes[setType]
        
        if let last = lastNotification, availableQuotes.count > 1 {
            availableQuotes.removeAll() { $0 == last }
            
        }
        
        let chosen = availableQuotes.randomElement() ?? "Keep Going!"
        
        lastNotification = chosen
        return chosen
//        return available.count ?? quotes[setType].count chosen : available
        
    }
    func scheduleNotification(for task: Task) {  // Adjust 'Task' to your actual task type name
        let dueDate = task.dueDate
        
        scheduleNotification(
            title: task.title,
            body: newNotificationBody(for: UserDefaults.standard.integer(forKey: "notificationType")),
            date: dueDate,
            id: task.id
        )
    }
}
