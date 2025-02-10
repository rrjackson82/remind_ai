import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/daneohr/Downloads/Xcode Projects/Reminder Roast/Reminder Roast/Reminder Roast/SettingsView.swift", line: 1)
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
                Section(header: Text(__designTimeString("#11847_0", fallback: "Notifications"))) {
                    Menu {
                        Button(__designTimeString("#11847_1", fallback: "Encouraging 😊")) { updateNotificationType(__designTimeInteger("#11847_2", fallback: 0)) }
                        Button(__designTimeString("#11847_3", fallback: "Neutral ✨")) { updateNotificationType(__designTimeInteger("#11847_4", fallback: 1)) }
                        Button(__designTimeString("#11847_5", fallback: "Roast Me 🔥")) { updateNotificationType(__designTimeInteger("#11847_6", fallback: 2)) }
                    } label: {
                        HStack {
                            Text(__designTimeString("#11847_7", fallback: "Type"))
                            Spacer()
                            Text(notificationTypeText) // Shows the current selection
                                .foregroundColor(.gray)
                            Image(systemName: __designTimeString("#11847_8", fallback: "chevron.down")) // Visual hint for dropdown
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
            .navigationTitle(__designTimeString("#11847_9", fallback: "Settings"))
        }
    }

    // Computed property to display selected type as text
    private var notificationTypeText: String {
        switch selectedType {
        case 0: return __designTimeString("#11847_10", fallback: "Encouraging 😊")
        case 1: return __designTimeString("#11847_11", fallback: "Neutral ✨")
        case 2: return __designTimeString("#11847_12", fallback: "Roast Me 🔥")
        default: return __designTimeString("#11847_13", fallback: "Unknown")
        }
    }

    // Function to update selection & save to UserDefaults
    private func updateNotificationType(_ type: Int) {
        withAnimation {
            selectedType = type
            UserDefaults.standard.set(type, forKey: __designTimeString("#11847_14", fallback: "notificationType"))
        }
    }
}

#Preview{
    SettingsView()
}
