import SwiftUI

struct HomeView: View {
    @StateObject var taskManager = TaskManager()
    @State private var showingNewListSheet = false
    @State private var showingEditSheet = false
    @State private var editingList: ReminderList?
    @State private var listName = ""
    @State private var selectedIcon = "list.bullet"
    @State private var selectedColor = "blue"
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: TodayView(taskManager: taskManager)) {
                        HStack {
                            Label("Today", systemImage: "sun.max")
                            Spacer()
                            Text("\(taskManager.todayTasks.count)")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    NavigationLink(destination: AllTasksView(taskManager: taskManager)) {
                        HStack {
                            Label("All Tasks", systemImage: "tray.full")
                            Spacer()
                            Text("\(taskManager.allTasks.count)")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    NavigationLink(destination: CompletedTasksView(taskManager: taskManager)) {
                        HStack {
                            Label("Completed", systemImage: "checkmark.circle")
                            Spacer()
                            Text("\(taskManager.allCompletedTasks.count)")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    NavigationLink(destination: CalendarView(taskManager: taskManager)) {
                        Label("Calendar", systemImage: "calendar")
                    }
                }
                
                if !pinnedLists.isEmpty {
                    Section("Pinned") {
                        ForEach(pinnedLists) { list in
                            ListRowView(list: list, taskManager: taskManager) {
                                editingList = list
                                listName = list.name
                                selectedIcon = list.icon
                                selectedColor = list.color
                                showingEditSheet = true
                            }
                        }
                    }
                }
                
                Section("My Lists") {
                    ForEach(unpinnedLists) { list in
                        ListRowView(list: list, taskManager: taskManager) {
                            editingList = list
                            listName = list.name
                            selectedIcon = list.icon
                            selectedColor = list.color
                            showingEditSheet = true
                        }
                    }
                }
            }
            .navigationTitle("My Lists")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        listName = ""
                        selectedIcon = "list.bullet"
                        selectedColor = "blue"
                        showingNewListSheet = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewListSheet) {
                ListEditView(
                    title: "New List",
                    name: $listName,
                    icon: $selectedIcon,
                    color: $selectedColor,
                    onSave: {
                        taskManager.createList(name: listName, icon: selectedIcon, color: selectedColor)
                        showingNewListSheet = false
                    },
                    onCancel: { showingNewListSheet = false }
                )
            }
            .sheet(isPresented: $showingEditSheet) {
                if let list = editingList {
                    ListEditView(
                        title: "Edit List",
                        name: $listName,
                        icon: $selectedIcon,
                        color: $selectedColor,
                        onSave: {
                            let updatedList = ReminderList(
                                id: list.id,
                                name: listName,
                                icon: selectedIcon,
                                color: selectedColor,
                                sections: list.sections
                            )
                            taskManager.updateList(updatedList)
                            showingEditSheet = false
                        },
                        onCancel: { showingEditSheet = false }
                    )
                }
            }
            .onChange(of: showingEditSheet) { oldValue, newValue in
                if !newValue {
                    editingList = nil
                }
            }
        }
    }
    
    private var pinnedLists: [ReminderList] {
        taskManager.lists.filter { $0.isPinned }
    }
    
    private var unpinnedLists: [ReminderList] {
        taskManager.lists.filter { !$0.isPinned }
    }
}

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
                    .foregroundColor(colorFromString(list.color))
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
        default: return .blue
        }
    }
} 