import SwiftUI

struct ColorButton: View {
    let colorName: String
    let colorValue: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(colorValue)
                .frame(width: 30, height: 30)
                .overlay(
                    Circle()
                        .strokeBorder(isSelected ? .gray : .clear, lineWidth: 2)
                )
                .shadow(radius: isSelected ? 3 : 1)
        }
    }
}

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

struct ColorPickerSection: View {
    @Binding var selectedColor: String
    let availableColors: [(String, Color)]
    
    var body: some View {
        Section(header: Text("Color")) {
            HStack(spacing: 12) {
                ForEach(availableColors, id: \.0) { colorName, colorValue in
                    ColorButton(
                        colorName: colorName,
                        colorValue: colorValue,
                        isSelected: selectedColor.lowercased() == colorName.lowercased(),
                        action: { selectedColor = colorName }
                    )
                }
            }
            .padding(.vertical, 8)
        }
    }
}

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
                
                ColorPickerSection(selectedColor: $color, availableColors: availableColors)
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
