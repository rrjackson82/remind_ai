import func SwiftUI.__designTimeSelection

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
    
    var body: some View {
        __designTimeSelection(Button(action: {
            __designTimeSelection(action(), "#4620.[1].[4].property.[0].[0].arg[0].value.[0]")
            __designTimeSelection(print("Tapped on color: \(__designTimeSelection(colorName, "#4620.[1].[4].property.[0].[0].arg[0].value.[1].arg[0].value.[1].value.arg[0].value"))"), "#4620.[1].[4].property.[0].[0].arg[0].value.[1]")  // Debugging output
        }) {
            __designTimeSelection(Circle()
                .fill(__designTimeSelection(colorValue, "#4620.[1].[4].property.[0].[0].arg[1].value.[0].modifier[0].arg[0].value"))
                .frame(width: __designTimeInteger("#4620_0", fallback: 30), height: __designTimeInteger("#4620_1", fallback: 30))
                .overlay(
                    __designTimeSelection(Circle()
                        .strokeBorder(isSelected ? .gray : .clear, lineWidth: __designTimeInteger("#4620_2", fallback: 2)), "#4620.[1].[4].property.[0].[0].arg[1].value.[0].modifier[2].arg[0].value")
                )
                .shadow(radius: isSelected ? __designTimeInteger("#4620_3", fallback: 3) : __designTimeInteger("#4620_4", fallback: 1)), "#4620.[1].[4].property.[0].[0].arg[1].value.[0]")
        }, "#4620.[1].[4].property.[0].[0]")
    }
}

// 🔹 IconButton View (Displays an icon option)
struct IconButton: View {
    let iconName: String
    let isSelected: Bool
    let scale: CGFloat
    let action: () -> Void
    
    var body: some View {
        __designTimeSelection(Button(action: __designTimeSelection(action, "#4620.[2].[4].property.[0].[0].arg[0].value")) {
            __designTimeSelection(Image(systemName: __designTimeSelection(iconName, "#4620.[2].[4].property.[0].[0].arg[1].value.[0].arg[0].value"))
                .font(.title2)
                .frame(width: __designTimeInteger("#4620_5", fallback: 44), height: __designTimeInteger("#4620_6", fallback: 44))
                .foregroundColor(isSelected ? .accentColor : .gray)
                .background(
                    __designTimeSelection(RoundedRectangle(cornerRadius: __designTimeInteger("#4620_7", fallback: 8))
                        .fill(isSelected ? Color.accentColor.opacity(__designTimeFloat("#4620_8", fallback: 0.2)) : Color.clear), "#4620.[2].[4].property.[0].[0].arg[1].value.[0].modifier[3].arg[0].value")
                )
                .scaleEffect(__designTimeSelection(scale, "#4620.[2].[4].property.[0].[0].arg[1].value.[0].modifier[4].arg[0].value")), "#4620.[2].[4].property.[0].[0].arg[1].value.[0]")
        }
        .buttonStyle(__designTimeSelection(PlainButtonStyle(), "#4620.[2].[4].property.[0].[0].modifier[0].arg[0].value")), "#4620.[2].[4].property.[0].[0]")
    }
}

// 🔹 Color Picker Section (Handles color selection)
struct ColorPickerSection: View {
    @Binding var selectedColor: String
    let availableColors: [(String, Color)]
    @State private var lastSelectedColor: String? // Prevents unnecessary updates

    var body: some View {
        __designTimeSelection(Section(header: __designTimeSelection(Text(__designTimeString("#4620_9", fallback: "Color")), "#4620.[3].[3].property.[0].[0].arg[0].value")) {
            __designTimeSelection(HStack(spacing: __designTimeInteger("#4620_10", fallback: 12)) {
                __designTimeSelection(ForEach(__designTimeSelection(availableColors, "#4620.[3].[3].property.[0].[0].arg[1].value.[0].arg[1].value.[0].arg[0].value"), id: \.0) { colorName, colorValue in
                    __designTimeSelection(ColorButton(
                        colorName: __designTimeSelection(colorName, "#4620.[3].[3].property.[0].[0].arg[1].value.[0].arg[1].value.[0].arg[2].value.[0].arg[0].value"),
                        colorValue: __designTimeSelection(colorValue, "#4620.[3].[3].property.[0].[0].arg[1].value.[0].arg[1].value.[0].arg[2].value.[0].arg[1].value"),
                        isSelected: selectedColor == colorName,
                        action: {
                            if lastSelectedColor != colorName { // Only update if different
                                lastSelectedColor = colorName
                                selectedColor = colorName.lowercased()
                                __designTimeSelection(print("Selected color changed to: \(__designTimeSelection(selectedColor, "#4620.[3].[3].property.[0].[0].arg[1].value.[0].arg[1].value.[0].arg[2].value.[0].arg[3].value.[0].[0].[2].arg[0].value.[1].value.arg[0].value"))"), "#4620.[3].[3].property.[0].[0].arg[1].value.[0].arg[1].value.[0].arg[2].value.[0].arg[3].value.[0].[0].[2]") // Debugging
                            }
                        }
                    ), "#4620.[3].[3].property.[0].[0].arg[1].value.[0].arg[1].value.[0].arg[2].value.[0]")
                }, "#4620.[3].[3].property.[0].[0].arg[1].value.[0].arg[1].value.[0]")
            }
            .padding(.vertical, __designTimeInteger("#4620_11", fallback: 8)), "#4620.[3].[3].property.[0].[0].arg[1].value.[0]")
        }, "#4620.[3].[3].property.[0].[0]")
    }
}

// 🔹 Icon Picker Section (Handles icon selection)
struct IconPickerSection: View {
    @Binding var selectedIcon: String
    let commonIcons: [String]
    @State private var selectedIconScale: CGFloat = 1.0
    
    var body: some View {
        __designTimeSelection(Section(header: __designTimeSelection(Text(__designTimeString("#4620_12", fallback: "Icon")), "#4620.[4].[3].property.[0].[0].arg[0].value")) {
            __designTimeSelection(LazyVGrid(columns: [GridItem(__designTimeSelection(.adaptive(minimum: __designTimeInteger("#4620_13", fallback: 44)), "#4620.[4].[3].property.[0].[0].arg[1].value.[0].arg[0].value.[0].arg[0]"))], spacing: __designTimeInteger("#4620_14", fallback: 10)) {
                __designTimeSelection(ForEach(__designTimeSelection(commonIcons, "#4620.[4].[3].property.[0].[0].arg[1].value.[0].arg[2].value.[0].arg[0].value"), id: \.self) { iconName in
                    __designTimeSelection(IconButton(
                        iconName: __designTimeSelection(iconName, "#4620.[4].[3].property.[0].[0].arg[1].value.[0].arg[2].value.[0].arg[2].value.[0].arg[0].value"),
                        isSelected: selectedIcon == iconName,
                        scale: selectedIcon == iconName ? selectedIconScale : __designTimeFloat("#4620_15", fallback: 1.0),
                        action: {
                            __designTimeSelection(withAnimation(__designTimeSelection(.spring(response: __designTimeFloat("#4620_16", fallback: 0.3), dampingFraction: __designTimeFloat("#4620_17", fallback: 0.6)), "#4620.[4].[3].property.[0].[0].arg[1].value.[0].arg[2].value.[0].arg[2].value.[0].arg[3].value.[0].arg[0]")) {
                                selectedIcon = iconName
                                selectedIconScale = __designTimeFloat("#4620_18", fallback: 1.3)
                                __designTimeSelection(DispatchQueue.main.asyncAfter(deadline: .now() + __designTimeFloat("#4620_19", fallback: 0.1)) {
                                    __designTimeSelection(withAnimation(__designTimeSelection(.spring(response: __designTimeFloat("#4620_20", fallback: 0.3), dampingFraction: __designTimeFloat("#4620_21", fallback: 0.6)), "#4620.[4].[3].property.[0].[0].arg[1].value.[0].arg[2].value.[0].arg[2].value.[0].arg[3].value.[0].arg[1].value.[2].modifier[0].arg[1].value.[0].arg[0]")) {
                                        selectedIconScale = __designTimeFloat("#4620_22", fallback: 1.0)
                                    }, "#4620.[4].[3].property.[0].[0].arg[1].value.[0].arg[2].value.[0].arg[2].value.[0].arg[3].value.[0].arg[1].value.[2].modifier[0].arg[1].value.[0]")
                                }, "#4620.[4].[3].property.[0].[0].arg[1].value.[0].arg[2].value.[0].arg[2].value.[0].arg[3].value.[0].arg[1].value.[2]")
                            }, "#4620.[4].[3].property.[0].[0].arg[1].value.[0].arg[2].value.[0].arg[2].value.[0].arg[3].value.[0]")
                        }
                    ), "#4620.[4].[3].property.[0].[0].arg[1].value.[0].arg[2].value.[0].arg[2].value.[0]")
                }, "#4620.[4].[3].property.[0].[0].arg[1].value.[0].arg[2].value.[0]")
            }
            .padding(.vertical, __designTimeInteger("#4620_23", fallback: 8)), "#4620.[4].[3].property.[0].[0].arg[1].value.[0]")
        }, "#4620.[4].[3].property.[0].[0]")
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
        ("blue", __designTimeSelection(Color.blue, "#4620.[5].[6].value.[0].[1]")),
        ("red", __designTimeSelection(Color.red, "#4620.[5].[6].value.[1].[1]")),
        ("green", __designTimeSelection(Color.green, "#4620.[5].[6].value.[2].[1]")),
        ("purple", __designTimeSelection(Color.purple, "#4620.[5].[6].value.[3].[1]")),
        ("orange", __designTimeSelection(Color.orange, "#4620.[5].[6].value.[4].[1]")),
        ("white", __designTimeSelection(Color.white, "#4620.[5].[6].value.[5].[1]"))
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
        __designTimeSelection(NavigationView {
            __designTimeSelection(Form {
                __designTimeSelection(Section {
                    __designTimeSelection(TextField(__designTimeString("#4620_24", fallback: "List Name"), text: __designTimeSelection($name, "#4620.[5].[8].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[0].value.[0].arg[1].value")), "#4620.[5].[8].property.[0].[0].arg[0].value.[0].arg[0].value.[0].arg[0].value.[0]")
                }, "#4620.[5].[8].property.[0].[0].arg[0].value.[0].arg[0].value.[0]")
                
                // 🔹 Color Picker Section
                __designTimeSelection(ColorPickerSection(
                    selectedColor: __designTimeSelection($color, "#4620.[5].[8].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[0].value"),
                    availableColors: __designTimeSelection(availableColors, "#4620.[5].[8].property.[0].[0].arg[0].value.[0].arg[0].value.[1].arg[1].value")
                )
                .onChange(of: __designTimeSelection(color, "#4620.[5].[8].property.[0].[0].arg[0].value.[0].arg[0].value.[1].modifier[0].arg[0].value")) { oldValue, newValue in
                    color = newValue.lowercased() // Force lowercase for consistency
                }, "#4620.[5].[8].property.[0].[0].arg[0].value.[0].arg[0].value.[1]")

                // 🔹 Icon Picker Section (RESTORED ✅)
                __designTimeSelection(IconPickerSection(selectedIcon: __designTimeSelection($icon, "#4620.[5].[8].property.[0].[0].arg[0].value.[0].arg[0].value.[2].arg[0].value"), commonIcons: __designTimeSelection(commonIcons, "#4620.[5].[8].property.[0].[0].arg[0].value.[0].arg[0].value.[2].arg[1].value")), "#4620.[5].[8].property.[0].[0].arg[0].value.[0].arg[0].value.[2]")
            }
            .navigationTitle(__designTimeSelection(title, "#4620.[5].[8].property.[0].[0].arg[0].value.[0].modifier[0].arg[0].value"))
            .navigationBarItems(
                leading: __designTimeSelection(Button(__designTimeString("#4620_25", fallback: "Cancel"), action: __designTimeSelection(onCancel, "#4620.[5].[8].property.[0].[0].arg[0].value.[0].modifier[1].arg[0].value.arg[1].value")), "#4620.[5].[8].property.[0].[0].arg[0].value.[0].modifier[1].arg[0].value"),
                trailing: __designTimeSelection(Button(__designTimeString("#4620_26", fallback: "Save"), action: __designTimeSelection(onSave, "#4620.[5].[8].property.[0].[0].arg[0].value.[0].modifier[1].arg[1].value.arg[1].value"))
                    .disabled(__designTimeSelection(name.isEmpty, "#4620.[5].[8].property.[0].[0].arg[0].value.[0].modifier[1].arg[1].value.modifier[0].arg[0].value")), "#4620.[5].[8].property.[0].[0].arg[0].value.[0].modifier[1].arg[1].value")
            ), "#4620.[5].[8].property.[0].[0].arg[0].value.[0]")
        }, "#4620.[5].[8].property.[0].[0]")
    }
}

// 🔹 Example Preview
struct ListEditView_Previews: PreviewProvider {
    static var previews: some View {
        @State var name = __designTimeString("#4620_27", fallback: "My List")
        @State var icon = __designTimeString("#4620_28", fallback: "list.bullet")
        @State var color = __designTimeString("#4620_29", fallback: "blue")  // Default color
        
        return __designTimeSelection(ListEditView(
            title: __designTimeString("#4620_30", fallback: "Edit List"),
            name: __designTimeSelection($name, "#4620.[6].[0].property.[0].[3].arg[1].value"),
            icon: __designTimeSelection($icon, "#4620.[6].[0].property.[0].[3].arg[2].value"),
            color: __designTimeSelection($color, "#4620.[6].[0].property.[0].[3].arg[3].value"),
            onSave: { __designTimeSelection(print(__designTimeString("#4620_31", fallback: "Saved")), "#4620.[6].[0].property.[0].[3].arg[4].value.[0]") },
            onCancel: { __designTimeSelection(print(__designTimeString("#4620_32", fallback: "Canceled")), "#4620.[6].[0].property.[0].[3].arg[5].value.[0]") }
        ), "#4620.[6].[0].property.[0].[3]")
    }
}
