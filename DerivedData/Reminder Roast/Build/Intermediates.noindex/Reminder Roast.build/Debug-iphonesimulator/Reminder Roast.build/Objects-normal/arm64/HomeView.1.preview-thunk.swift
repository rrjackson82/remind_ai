import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/daneohr/Downloads/Xcode Projects/Reminder Roast/Reminder Roast/Reminder Roast/HomeView.swift", line: 1)
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
                            Label(__designTimeString("#10424_0", fallback: "Today"), systemImage: __designTimeString("#10424_1", fallback: "sun.max"))
                            Spacer()
                            Text("\(taskManager.todayTasks.count)")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    NavigationLink(destination: AllTasksView(taskManager: taskManager)) {
                        HStack {
                            Label(__designTimeString("#10424_2", fallback: "All Tasks"), systemImage: __designTimeString("#10424_3", fallback: "tray.full"))
                            Spacer()
                            Text("\(taskManager.allTasks.count)")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    NavigationLink(destination: CompletedTasksView(taskManager: taskManager)) {
                        HStack {
                            Label(__designTimeString("#10424_4", fallback: "Completed"), systemImage: __designTimeString("#10424_5", fallback: "checkmark.circle"))
                            Spacer()
                            Text("\(taskManager.allCompletedTasks.count)")
                                .foregroundColor(.gray)
                        }
                    }
                    
                    NavigationLink(destination: CalendarView(taskManager: taskManager)) {
                        Label(__designTimeString("#10424_6", fallback: "Calendar"), systemImage: __designTimeString("#10424_7", fallback: "calendar"))
                    }
                }
                
                if !pinnedLists.isEmpty {
                    Section(__designTimeString("#10424_8", fallback: "Pinned")) {
                        ForEach(pinnedLists) { list in
                            ListRowView(list: list, taskManager: taskManager) {
                                editingList = list
                                listName = list.name
                                selectedIcon = list.icon
                                selectedColor = list.color
                                showingEditSheet = __designTimeBoolean("#10424_9", fallback: true)
                            }
                        }
                    }
                }
                
                Section(__designTimeString("#10424_10", fallback: "My Lists")) {
                    ForEach(unpinnedLists) { list in
                        ListRowView(list: list, taskManager: taskManager) {
                            editingList = list
                            listName = list.name
                            selectedIcon = list.icon
                            selectedColor = list.color
                            showingEditSheet = __designTimeBoolean("#10424_11", fallback: true)
                        }
                    }
                }
            }
            .navigationTitle(__designTimeString("#10424_12", fallback: "My Lists"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        listName = __designTimeString("#10424_13", fallback: "")
                        selectedIcon = __designTimeString("#10424_14", fallback: "list.bullet")
                        selectedColor = __designTimeString("#10424_15", fallback: "blue")
                        showingNewListSheet = __designTimeBoolean("#10424_16", fallback: true)
                    }) {
                        Image(systemName: __designTimeString("#10424_17", fallback: "plus"))
                    }
                }
            }
            .sheet(isPresented: $showingNewListSheet) {
                ListEditView(
                    title: __designTimeString("#10424_18", fallback: "New List"),
                    name: $listName,
                    icon: $selectedIcon,
                    color: $selectedColor,
                    onSave: {
                        taskManager.createList(name: listName, icon: selectedIcon, color: selectedColor)
                        showingNewListSheet = __designTimeBoolean("#10424_19", fallback: false)
                    },
                    onCancel: { showingNewListSheet = __designTimeBoolean("#10424_20", fallback: false) }
                )
            }
            .sheet(isPresented: $showingEditSheet) {
                if let list = editingList {
                    ListEditView(
                        title: __designTimeString("#10424_21", fallback: "Edit List"),
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
                            showingEditSheet = __designTimeBoolean("#10424_22", fallback: false)
                        },
                        onCancel: { showingEditSheet = __designTimeBoolean("#10424_23", fallback: false) }
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
        list.sections.reduce(__designTimeInteger("#10424_24", fallback: 0)) { count, section in
            count + taskManager.incompleteTasks(in: section.id, listId: list.id).count
        }
    }
    
    var body: some View {
        NavigationLink(destination: TaskListView(taskManager: taskManager, list: list)) {
            HStack {
                Image(systemName: list.icon)
                    .foregroundColor(colorFromString(list.color))
                    .font(.system(size: __designTimeInteger("#10424_25", fallback: 20)))
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
                Label(__designTimeString("#10424_26", fallback: "Delete"), systemImage: __designTimeString("#10424_27", fallback: "trash"))
            }
            
            Button(action: onEdit) {
                Label(__designTimeString("#10424_28", fallback: "Edit"), systemImage: __designTimeString("#10424_29", fallback: "pencil"))
            }
            .tint(.blue)
        }
        .swipeActions(edge: .leading) {
            Button {
                taskManager.togglePinList(list.id)
            } label: {
                Label(list.isPinned ? __designTimeString("#10424_30", fallback: "Unpin") : __designTimeString("#10424_31", fallback: "Pin"), 
                      systemImage: list.isPinned ? __designTimeString("#10424_32", fallback: "pin.slash") : __designTimeString("#10424_33", fallback: "pin"))
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
