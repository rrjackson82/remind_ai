import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/daneohr/Downloads/Xcode Projects/Reminder Roast/Reminder Roast/Reminder Roast/SettingsView.swift", line: 1)
import SwiftUI

struct SettingsView: View {
    @State private var selectedType = UserDefaults.standard.integer(forKey: "notificationType")
    @State private var fireEmojis: [FireEmoji] = [] // Array to track falling fire
    @State private var fireEmojiCount = 0 // Control number of fire emojis

    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    Section(header: Text(__designTimeString("#11847_0", fallback: "Notifications"))) {
                        Menu {
                            Button(__designTimeString("#11847_1", fallback: "Encouraging 😊")) { updateNotificationType(__designTimeInteger("#11847_2", fallback: 0)) }
                            Button(__designTimeString("#11847_3", fallback: "Neutral ✨")) { updateNotificationType(__designTimeInteger("#11847_4", fallback: 1)) }
                            Button(__designTimeString("#11847_5", fallback: "Roast Me 🔥")) { triggerFireEffect() }
                        } label: {
                            HStack {
                                Text(__designTimeString("#11847_6", fallback: "Type"))
                                Spacer()
                                Text(notificationTypeText)
                                    .foregroundColor(.gray)
                                Image(systemName: __designTimeString("#11847_7", fallback: "chevron.down"))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .navigationTitle(__designTimeString("#11847_8", fallback: "Settings"))
            }

            // Fire Emojis Falling Animation
            ForEach(fireEmojis) { fire in
                Text(__designTimeString("#11847_9", fallback: "🔥"))
                    .font(.largeTitle)
                    .position(fire.position)
                    .opacity(fire.opacity)
                    .animation(.easeIn(duration: __designTimeFloat("#11847_10", fallback: 1.5)), value: fire.position) // Animate fall
            }
        }
    }

    // Computed property to display selected type as text
    private var notificationTypeText: String {
        switch selectedType {
        case 0: return __designTimeString("#11847_11", fallback: "Encouraging 😊")
        case 1: return __designTimeString("#11847_12", fallback: "Neutral ✨")
        case 2: return __designTimeString("#11847_13", fallback: "Roast Me 🔥")
        default: return __designTimeString("#11847_14", fallback: "Unknown")
        }
    }

    // Function to update selection & save to UserDefaults
    private func updateNotificationType(_ type: Int) {
        withAnimation {
            selectedType = type
            UserDefaults.standard.set(type, forKey: __designTimeString("#11847_15", fallback: "notificationType"))
        }
    }

    // Function to trigger fire animation
    private func triggerFireEffect() {
        updateNotificationType(__designTimeInteger("#11847_16", fallback: 2)) // Save selection
        fireEmojis = [] // Reset the emojis array
        fireEmojiCount = __designTimeInteger("#11847_17", fallback: 0) // Reset emoji count

        // Add 125 fire emojis to fall
        for _ in __designTimeInteger("#11847_18", fallback: 1)...__designTimeInteger("#11847_19", fallback: 125) {
            // Random delay for each fire emoji to make them fall at different times
            let randomDelay = Double.random(in: __designTimeFloat("#11847_20", fallback: 0.0)...__designTimeFloat("#11847_21", fallback: 0.3))
            DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay + Double(fireEmojiCount) * __designTimeFloat("#11847_22", fallback: 0.1)) {
                addFireEmoji()
                fireEmojiCount += __designTimeInteger("#11847_23", fallback: 1)
            }
        }
    }

    // Add a fire emoji with random positions
    private func addFireEmoji() {
        let randomX = CGFloat.random(in: __designTimeInteger("#11847_24", fallback: 15)...UIScreen.main.bounds.width - __designTimeInteger("#11847_25", fallback: 15)) // Random X position
        let startY = CGFloat.random(in: __designTimeInteger("#11847_26", fallback: -75)...__designTimeInteger("#11847_27", fallback: 0)) // Start slightly above screen
        let endY = UIScreen.main.bounds.height + __designTimeInteger("#11847_28", fallback: 50) // Fall beyond bottom

        let fire = FireEmoji(
            id: UUID(),
            position: CGPoint(x: randomX, y: startY),
            opacity: __designTimeFloat("#11847_29", fallback: 1.0)
        )

        fireEmojis.append(fire)

        // Immediately start the fall animation for the fire emoji as it spawns
        withAnimation(.easeIn(duration: __designTimeFloat("#11847_30", fallback: 1.5))) {
            // Update the position and opacity to animate the fall
            if let index = fireEmojis.firstIndex(where: { $0.id == fire.id }) {
                fireEmojis[index].position.y = endY // Move down
                fireEmojis[index].opacity = __designTimeInteger("#11847_31", fallback: 0) // Fade out
            }
        }
    }
}

// Struct for tracking falling fire
struct FireEmoji: Identifiable {
    let id: UUID
    var position: CGPoint
    var opacity: Double
}

#Preview{
    SettingsView()
}
