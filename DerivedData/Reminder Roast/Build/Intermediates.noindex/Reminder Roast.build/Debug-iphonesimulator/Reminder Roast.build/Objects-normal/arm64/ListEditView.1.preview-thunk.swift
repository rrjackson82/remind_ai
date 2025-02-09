import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/daneohr/Downloads/Xcode Projects/Reminder Roast/Reminder Roast/Reminder Roast/ListEditView.swift", line: 1)
import SwiftUI

// 🔹 ColorButton View (Displays a color option)
struct ColorButton: View {
    let colorName: String
    let colorValue: Color
    let isSelected: Bool
    let action: () -> Void
    
    @State private var pressed = false  // Local state to track button press
    
    var body: some View {
        Button(action: {
            action() // Call the action passed in from the parent
            pressed = __designTimeBoolean("#4620_0", fallback: true)  // Mark as pressed
            print("Tapped on color: \(colorName)")  // Debugging log
        }) {
            Circle()
                .fill(colorValue)
                .frame(width: __designTimeInteger("#4620_1", fallback: 30), height: __designTimeInteger("#4620_2", fallback: 30))
                .overlay(
                    Circle()
                        .strokeBorder(isSelected ? .gray : .clear, lineWidth: __designTimeInteger("#4620_3", fallback: 2))
                )
                .shadow(radius: isSelected ? __designTimeInteger("#4620_4", fallback: 3) : __designTimeInteger("#4620_5", fallback: 1))
                .scaleEffect(pressed ? __designTimeFloat("#4620_6", fallback: 1.1) : __designTimeFloat("#4620_7", fallback: 1.0))  // Add a scaling effect on press
        }
        .buttonStyle(PlainButtonStyle()) // Disable default button style to prevent layout issues
    }
}

// 🔹 IconButton View (Displays an icon option)
struct IconButton: View {
    let iconName: String
    let isSelected: Bool
    let scale: CGFloat
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.title2)
                .frame(width: __designTimeInteger("#4620_8", fallback: 44), height: __designTimeInteger("#4620_9", fallback: 44))
                .foregroundColor(isSelected ? .accentColor : .gray)
                .background(
                    RoundedRectangle(cornerRadius: __designTimeInteger("#4620_10", fallback: 8))
                        .fill(isSelected ? Color.accentColor.opacity(__designTimeFloat("#4620_11", fallback: 0.2)) : Color.clear)
                )
                .scaleEffect(scale)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// 🔹 Color Picker Section (Handles color selection)
struct ColorPickerSection: View {
    @Binding var selectedColor: String
    let availableColors: [(String, Color)]  // List of available colors
    @Environment(\.colorScheme) var colorScheme  // Get the current color scheme
    
    var body: some View {
        Section(header: Text(__designTimeString("#4620_12", fallback: "Color"))) {
            HStack(spacing: __designTimeInteger("#4620_13", fallback: 12)) {
                ForEach(availableColors, id: \.0) { colorName, colorValue in
                    ColorButton(
                        colorName: colorName,
                        colorValue: colorName == __designTimeString("#4620_14", fallback: "White") ? (colorScheme == .dark ? Color.black : Color.white) : colorValue,
                        isSelected: selectedColor == colorName,
                        action: {
                            if selectedColor != colorName {
                                selectedColor = colorName.lowercased()
                                print("Selected color changed to: \(selectedColor)")
                            }
                        }
                    )
                }
            }
            .padding(.vertical, __designTimeInteger("#4620_15", fallback: 8))
        }
    }
}

// 🔹 Icon Picker Section (Handles icon selection)
struct IconPickerSection: View {
    @Binding var selectedIcon: String
    let commonIcons: [String]
    @State private var selectedIconScale: CGFloat = 1.0
    
    var body: some View {
        Section(header: Text(__designTimeString("#4620_16", fallback: "Icon"))) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: __designTimeInteger("#4620_17", fallback: 44)))], spacing: __designTimeInteger("#4620_18", fallback: 10)) {
                ForEach(commonIcons, id: \.self) { iconName in
                    IconButton(
                        iconName: iconName,
                        isSelected: selectedIcon == iconName,
                        scale: selectedIcon == iconName ? selectedIconScale : __designTimeFloat("#4620_19", fallback: 1.0),
                        action: {
                            withAnimation(.spring(response: __designTimeFloat("#4620_20", fallback: 0.3), dampingFraction: __designTimeFloat("#4620_21", fallback: 0.6))) {
                                selectedIcon = iconName
                                selectedIconScale = __designTimeFloat("#4620_22", fallback: 1.3)
                                DispatchQueue.main.asyncAfter(deadline: .now() + __designTimeFloat("#4620_23", fallback: 0.1)) {
                                    withAnimation(.spring(response: __designTimeFloat("#4620_24", fallback: 0.3), dampingFraction: __designTimeFloat("#4620_25", fallback: 0.6))) {
                                        selectedIconScale = __designTimeFloat("#4620_26", fallback: 1.0)
                                    }
                                }
                            }
                        }
                    )
                }
            }
            .padding(.vertical, __designTimeInteger("#4620_27", fallback: 8))
        }
    }
}

// 🔹 List Edit View (Main View with Color and Icon Selection)
struct ListEditView: View {
    let title: String
    @Binding var name: String
    @Binding var icon: String
    @Binding var color: String  // Correctly bind to color state
    let onSave: () -> Void
    let onCancel: () -> Void
    
    let availableColors = [
        ("Blue", Color.blue),
        ("Red", Color.red),
        ("Green", Color.green),
        ("Purple", Color.purple),
        ("Orange", Color.orange),
        ("White", Color.white)
    ]
    
    let commonIcons = [
                "list.bullet", "checklist", "doc.text", "folder",
                "calendar", "clock", "bell", "flag",
                "graduationcap", "book.closed", "pencil", "backpack",
                "ruler", "books.vertical", "highlighter",
                "house", "cart", "gift", "heart",
                "star", "person", "carrot", "cart.fill",
                "fork.knife", "bed.double", "washer", "leaf",
                "gear", "bookmark", "tag", "folder.badge.plus"
            ]

    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField(__designTimeString("#4620_28", fallback: "List Name"), text: $name)
                }
                
                // Pass selectedColor as a binding
                ColorPickerSection(
                    selectedColor: $color,  // Properly bind to color state
                    availableColors: availableColors
                )
                
                // 🔹 Icon Picker Section (RESTORED ✅)
                   IconPickerSection(selectedIcon: $icon, commonIcons: commonIcons)
            }
            .navigationTitle(title)
            .navigationBarItems(
                leading: Button(__designTimeString("#4620_29", fallback: "Cancel"), action: onCancel),
                trailing: Button(__designTimeString("#4620_30", fallback: "Save"), action: onSave)
                    .disabled(name.isEmpty)
            )
        }
    }
}

// 🔹 Example Preview
struct ListEditView_Previews: PreviewProvider {
    static var previews: some View {
        @State var name = __designTimeString("#4620_31", fallback: "My List")
        @State var icon = __designTimeString("#4620_32", fallback: "list.bullet")
        @State var color = __designTimeString("#4620_33", fallback: "blue")  // Default color
        
        return ListEditView(
            title: __designTimeString("#4620_34", fallback: "Edit List"),
            name: $name,
            icon: $icon,
            color: $color,
            onSave: { print(__designTimeString("#4620_35", fallback: "Saved")) },
            onCancel: { print(__designTimeString("#4620_36", fallback: "Canceled")) }
        )
    }
}
