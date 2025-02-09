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
                .preferredColorScheme(.dark)
        }
    }
    func requestNotificationPermission() {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            }
        }
}
