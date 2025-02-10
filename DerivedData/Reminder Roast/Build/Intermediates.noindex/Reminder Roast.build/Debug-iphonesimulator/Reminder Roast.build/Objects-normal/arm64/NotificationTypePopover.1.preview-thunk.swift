import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/daneohr/Downloads/Xcode Projects/Reminder Roast/Reminder Roast/Reminder Roast/NotificationTypePopover.swift", line: 1)
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
            Text(__designTimeString("#13164_0", fallback: "Notification Style"))
                .font(.headline)
                .padding()

            Picker(__designTimeString("#13164_1", fallback: "Select Notification Type"), selection: $selectedType) {
                Text(__designTimeString("#13164_2", fallback: "Encouraging 😊")).tag(__designTimeInteger("#13164_3", fallback: 0))
                Text(__designTimeString("#13164_4", fallback: "Neutral ✨")).tag(__designTimeInteger("#13164_5", fallback: 1))
                Text(__designTimeString("#13164_6", fallback: "Roast Me 🔥")).tag(__designTimeInteger("#13164_7", fallback: 2))
            }
            .pickerStyle(WheelPickerStyle())
            .padding()

            Button(__designTimeString("#13164_8", fallback: "Save & Close")) {
                UserDefaults.standard.set(selectedType, forKey: __designTimeString("#13164_9", fallback: "notificationType"))
                isPresented = __designTimeBoolean("#13164_10", fallback: false)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(__designTimeInteger("#13164_11", fallback: 10))
        }
        .padding()
        .frame(width: __designTimeInteger("#13164_12", fallback: 300), height: __designTimeInteger("#13164_13", fallback: 250))
        .onAppear {
            selectedType = UserDefaults.standard.integer(forKey: __designTimeString("#13164_14", fallback: "notificationType"))
        }
    }
}
