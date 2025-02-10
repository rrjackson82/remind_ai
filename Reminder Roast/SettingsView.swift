import SwiftUI

struct SettingsView: View {
    @State private var selectedType = UserDefaults.standard.integer(forKey: "notificationType")
    @State private var fireEmojis: [FireEmoji] = [] // Array to track falling fire
    @State private var fireEmojiCount = 0 // Control number of fire emojis

    var body: some View {
        ZStack {
            NavigationView {
                Form {
                    Section(header: Text("Notifications")) {
                        Menu {
                            Button("Encouraging 😊") { updateNotificationType(0) }
                            Button("Neutral ✨") { updateNotificationType(1) }
                            Button("Roast Me 🔥") { triggerFireEffect() }
                        } label: {
                            HStack {
                                Text("Type")
                                Spacer()
                                Text(notificationTypeText)
                                    .foregroundColor(.gray)
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .navigationTitle("Settings")
            }

            // Fire Emojis Falling Animation
            ForEach(fireEmojis) { fire in
                Text("🔥")
                    .font(.largeTitle)
                    .position(fire.position)
                    .opacity(fire.opacity)
                    .animation(.easeIn(duration: 1.5), value: fire.position) // Animate fall
            }
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

    // Function to trigger fire animation
    private func triggerFireEffect() {
        updateNotificationType(2) // Save selection
        fireEmojis = [] // Reset the emojis array
        fireEmojiCount = 0 // Reset emoji count

        // Add 200 fire emojis to fall
        for _ in 1...200 {
            // Random delay for each fire emoji to make them fall at different times
            let randomDelay = Double.random(in: 0.0...0.3)
            DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay + Double(fireEmojiCount) * 0.1) {
                addFireEmoji()
                fireEmojiCount += 1
            }
        }
    }

    // Add a fire emoji with random positions
    private func addFireEmoji() {
        let randomX = CGFloat.random(in: 15...UIScreen.main.bounds.width - 15) // Random X position
        let startY = CGFloat.random(in: -200...0) // Start slightly above screen
        let endY = UIScreen.main.bounds.height + 50 // Fall beyond bottom

        let fire = FireEmoji(
            id: UUID(),
            position: CGPoint(x: randomX, y: startY),
            opacity: 1.0
        )

        fireEmojis.append(fire)

        // Immediately start the fall animation for the fire emoji as it spawns
        withAnimation(.easeIn(duration: 2.5)) {
            // Update the position and opacity to animate the fall
            if let index = fireEmojis.firstIndex(where: { $0.id == fire.id }) {
                fireEmojis[index].position.y = endY // Move down
                fireEmojis[index].opacity = 0 // Fade out
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
