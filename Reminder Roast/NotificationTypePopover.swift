//
//  NotificationTypePopover.swift
//  Reminder Roast
//
//  Created by Dane Ohr on 2/9/25.
//
import SwiftUI

struct NotificationTypePopover: View {
    @Binding var isPresented: Bool
    @Binding var selectedType: Int

    var body: some View {
        VStack {
            Text("Notification Style")
                .font(.headline)
                .padding()

            Picker("Select Notification Type", selection: $selectedType) {
                Text("Encouraging 😊").tag(0)
                Text("Neutral ✨").tag(1)
                Text("Roast Me 🔥").tag(2)
            }
            .pickerStyle(WheelPickerStyle())
            .padding()

            Button("Save & Close") {
                UserDefaults.standard.set(selectedType, forKey: "notificationType")
                isPresented = false
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .frame(width: 300, height: 250)
        .onAppear {
            selectedType = UserDefaults.standard.integer(forKey: "notificationType")
        }
    }
}
