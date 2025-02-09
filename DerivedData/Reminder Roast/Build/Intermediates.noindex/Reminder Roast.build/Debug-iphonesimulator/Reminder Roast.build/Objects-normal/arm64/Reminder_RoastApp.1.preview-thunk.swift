import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/daneohr/Downloads/Xcode Projects/Reminder Roast/Reminder Roast/Reminder Roast/Reminder_RoastApp.swift", line: 1)
//
//  Reminder_RoastApp.swift
//  Reminder Roast
//
//  Created by Dane Ohr on 2/8/25.
//

import SwiftUI
import UserNotifications

@main
struct Reminder_RoastApp: App {
    init() {
           requestNotificationPermission()
       }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    func requestNotificationPermission() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            }
        }
}
