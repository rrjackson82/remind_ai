//
//  OnboardingView.swift
//  Reminder Roast
//
//  Created by Dane Ohr on 2/9/25.
//
import SwiftUI

struct OnboardingView: View {
    @State private var selectedType: Int? = nil
    @State private var isOnboardingComplete = false

    var body: some View {
        if isOnboardingComplete {
            ContentView() // Replace with your main app view
        } else {
            VStack {
                Text("Choose your motivation style:")
                    .font(.headline)
                    .padding()

                Button(action: { selectType(0) }) {
                    Text("Encouraging 😊")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: { selectType(1) }) {
                    Text("Neutral ✨")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: { selectType(2) }) {
                    Text("Roast Me 🔥")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
            .onAppear {
                // Check if the user has already completed onboarding
                isOnboardingComplete = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
            }
        }
    }

    func selectType(_ type: Int) {
        UserDefaults.standard.set(type, forKey: "notificationType")
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        isOnboardingComplete = true
    }
}
