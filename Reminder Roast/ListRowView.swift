import SwiftUI

struct ListRowView: View {
    let list: ReminderList
    let taskManager: TaskManager
    let onEdit: () -> Void
    
    var incompleteTaskCount: Int {
        list.sections.reduce(0) { count, section in
            count + taskManager.incompleteTasks(in: section.id, listId: list.id).count
        }
    }
    
    var body: some View {
        NavigationLink(destination: TaskListView(taskManager: taskManager, list: list)) {
            HStack {
                Image(systemName: list.icon)
                    .foregroundColor(colorFromString(list.color))  // Ensure correct color based on list color
                    .font(.system(size: 20))
                Text(list.name)
                Spacer()
                Text("\(incompleteTaskCount)")
                    .foregroundColor(.gray)
            }
        }
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                taskManager.deleteList(list.id)
            } label: {
                Label("Delete", systemImage: "trash")
            }
            
            Button(action: onEdit) {
                Label("Edit", systemImage: "pencil")
            }
            .tint(.blue)
        }
        .swipeActions(edge: .leading) {
            Button {
                taskManager.togglePinList(list.id)
            } label: {
                Label(list.isPinned ? "Unpin" : "Pin",
                      systemImage: list.isPinned ? "pin.slash" : "pin")
            }
            .tint(.orange)
        }
    }
    
    private func colorFromString(_ colorString: String) -> Color {
        switch colorString.lowercased() {
        case "blue": return .blue
        case "red": return .red
        case "green": return .green
        case "purple": return .purple
        case "orange": return .orange
        case "white": return .white
        case "black": return .black  // Handle black color here
        default: return .blue
        }
    }
}
