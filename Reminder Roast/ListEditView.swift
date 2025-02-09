import SwiftUI

// 🔹 ColorButton View (Displays a color option)
struct ColorButton: View {
    let colorName: String
    let colorValue: Color
    let isSelected: Bool
    let action: () -> Void
    
    @State private var pressed = false  // Local state to track button press
    @State private var scale: CGFloat = 1.0  // For scaling effect
    @State private var overlayScale: CGFloat = 1.0
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Circle()
                .fill(colorValue)
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .strokeBorder(Color.white, lineWidth: 2)
                        .scaleEffect(1.25)  // Constant larger scale for the white circle
                        .opacity(isSelected ? 1 : 0)
                )
                .scaleEffect(isSelected ? 0.95 : 1.0)
//                .shadow(radius: isSelected ? 3 : 1)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.1), value: isSelected)
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
                    .frame(width: 44, height: 44)
                    .foregroundColor(isSelected ? .accentColor : .gray)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(isSelected ? Color.accentColor.opacity(0.2) : Color.clear)
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
            Section(header: Text("Color")) {
                HStack(spacing: 12) {
                    ForEach(availableColors, id: \.0) { colorName, colorValue in
                        ColorButton(
                            colorName: colorName,
                            colorValue: colorName == "White" ? (colorScheme == .dark ? Color.white : Color.black) : colorValue,
                            isSelected: selectedColor == colorName.lowercased(),
                            action: {
                                if selectedColor != colorName {
                                    selectedColor = colorName.lowercased()
                                    //                                print("Selected color changed to: \(selectedColor) LIST EDIT VIEW LINE 72")
                                }
                            }
                        )
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    // 🔹 Icon Picker Section (Handles icon selection)
    struct IconPickerSection: View {
        @Binding var selectedIcon: String
        let commonIcons: [String]
        @State private var selectedIconScale: CGFloat = 1.0
        
        var body: some View {
            Section(header: Text("Icon")) {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 10) {
                    ForEach(commonIcons, id: \.self) { iconName in
                        IconButton(
                            iconName: iconName,
                            isSelected: selectedIcon == iconName,
                            scale: selectedIcon == iconName ? selectedIconScale : 1.0,
                            action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    selectedIcon = iconName
                                    selectedIconScale = 1.3
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                            selectedIconScale = 1.0
                                        }
                                    }
                                }
                            }
                        )
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
    
    // 🔹 List Edit View (Main View with Color and Icon Selection)
    struct ListEditView: View {
        let title: String
        @Binding var name: String
        @Binding var icon: String
        @Binding var color: String
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
                        TextField("List Name", text: $name)
                    }
                    
                    ColorPickerSection(
                        selectedColor: $color,  // Correctly bind selected color here
                        availableColors: availableColors
                    )
                    // 🔹 Icon Picker Section (RESTORED ✅)
                    IconPickerSection(selectedIcon: $icon, commonIcons: commonIcons)
                }
                .navigationTitle(title)
                .navigationBarItems(
                    leading: Button("Cancel", action: onCancel),
                    trailing: Button("Save", action: onSave)
                        .disabled(name.isEmpty)
                )
            }
        }
    }
    
    // 🔹 Example Preview
    struct ListEditView_Previews: PreviewProvider {
        static var previews: some View {
            @State var name = "My List"
            @State var icon = "list.bullet"
            @State var color = "blue"  // Default color
            
            return ListEditView(
                title: "Edit List",
                name: $name,
                icon: $icon,
                color: $color,
                onSave: { print("Saved") },
                onCancel: { print("Canceled") }
            )
        }
    }

