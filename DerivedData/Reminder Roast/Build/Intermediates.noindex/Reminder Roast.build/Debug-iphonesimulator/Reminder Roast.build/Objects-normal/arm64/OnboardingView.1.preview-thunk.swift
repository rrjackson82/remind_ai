import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/daneohr/Downloads/Xcode Projects/Reminder Roast/Reminder Roast/Reminder Roast/OnboardingView.swift", line: 1)
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
//            ContentView()// Replace with your main app view
            HomeView()
        } else {
            VStack {
                Text(__designTimeString("#9816_0", fallback: "Choose your motivation style:"))
                    .font(.headline)
                    .padding()

                Button(action: { selectType(__designTimeInteger("#9816_1", fallback: 0)) }) {
                    Text(__designTimeString("#9816_2", fallback: "Encouraging 😊"))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(__designTimeFloat("#9816_3", fallback: 0.7)))
                        .foregroundColor(.white)
                        .cornerRadius(__designTimeInteger("#9816_4", fallback: 10))
                }

                Button(action: { selectType(__designTimeInteger("#9816_5", fallback: 1)) }) {
                    Text(__designTimeString("#9816_6", fallback: "Neutral ✨"))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(__designTimeFloat("#9816_7", fallback: 0.7)))
                        .foregroundColor(.white)
                        .cornerRadius(__designTimeInteger("#9816_8", fallback: 10))
                }

                Button(action: { selectType(__designTimeInteger("#9816_9", fallback: 2)) }) {
                    Text(__designTimeString("#9816_10", fallback: "Roast Me 🔥"))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(__designTimeFloat("#9816_11", fallback: 0.7)))
                        .foregroundColor(.white)
                        .cornerRadius(__designTimeInteger("#9816_12", fallback: 10))
                }
            }
            .padding()
            .onAppear {
                // Check if the user has already completed onboarding
                isOnboardingComplete = UserDefaults.standard.bool(forKey: __designTimeString("#9816_13", fallback: "hasCompletedOnboarding"))
            }
        }
    }

    func selectType(_ type: Int) {
        UserDefaults.standard.set(type, forKey: __designTimeString("#9816_14", fallback: "notificationType"))
        UserDefaults.standard.set(__designTimeBoolean("#9816_15", fallback: true), forKey: __designTimeString("#9816_16", fallback: "hasCompletedOnboarding"))
        isOnboardingComplete = __designTimeBoolean("#9816_17", fallback: true)
    }
}

#Preview {
    OnboardingView()
}
