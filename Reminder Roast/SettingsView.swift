//
//  SettingsView.swift
//  Reminder Roast
//
//  Created by Dane Ohr on 2/9/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedType = UserDefaults.standard.integer(forKey: "notificationType")

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Notifications")) {
                    Menu {
                        Button("Encouraging 😊") { updateNotificationType(0) }
                        Button("Neutral ✨") { updateNotificationType(1) }
                        Button("Roast Me 🔥") { updateNotificationType(2) }
                    } label: {
                        HStack {
                            Text("Type")
                            Spacer()
                            Text(notificationTypeText) // Shows the current selection
                                .foregroundColor(.gray)
                            Image(systemName: "chevron.right") // Visual hint for dropdown
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }

    // Computed property to display selected type as text
    private var notificationTypeText: String {
        switch selectedType {
        case 0: return "Encouraging 😊"
        case 1: return "Neutral ✨"
        case 2: return "Roast Me 🔥"
        default: return "Unknown"
        }
    }

    // Function to update selection & save to UserDefaults
    private func updateNotificationType(_ type: Int) {
        withAnimation {
            selectedType = type
            UserDefaults.standard.set(type, forKey: "notificationType")
        }
    }
}

#Preview{
    SettingsView()
}
