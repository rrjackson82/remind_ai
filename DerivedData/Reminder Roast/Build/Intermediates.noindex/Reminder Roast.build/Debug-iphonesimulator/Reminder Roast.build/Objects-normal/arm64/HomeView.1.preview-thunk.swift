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
    @State private var selectedColor = "blue" // Default color
    @State private var showingSettings = false // State for settings view
    
    @Environment(\.colorScheme) var colorScheme // Get the current color scheme (light/dark mode)

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) { // Aligns elements to the bottom right
                List {
                    Section {
                        NavigationLink(destination: TodayView(taskManager: taskManager)) {
                            HStack {
                                Label(__designTimeString("#7133_0", fallback: "Today"), systemImage: __designTimeString("#7133_1", fallback: "sun.max"))
                                Spacer()
                                Text("\(taskManager.todayTasks.count)")
                                    .foregroundColor(.gray)
                            }
                        }

                        NavigationLink(destination: AllTasksView(taskManager: taskManager)) {
                            HStack {
                                Label(__designTimeString("#7133_2", fallback: "All Tasks"), systemImage: __designTimeString("#7133_3", fallback: "tray.full"))
                                Spacer()
                                Text("\(taskManager.allTasks.count)")
                                    .foregroundColor(.gray)
                            }
                        }

                        NavigationLink(destination: CompletedTasksView(taskManager: taskManager)) {
                            HStack {
                                Label(__designTimeString("#7133_4", fallback: "Completed"), systemImage: __designTimeString("#7133_5", fallback: "checkmark.circle"))
                                Spacer()
                                Text("\(taskManager.allCompletedTasks.count)")
                                    .foregroundColor(.gray)
                            }
                        }

                        NavigationLink(destination: CalendarView(taskManager: taskManager)) {
                            Label(__designTimeString("#7133_6", fallback: "Calendar"), systemImage: __designTimeString("#7133_7", fallback: "calendar"))
                        }
                    }

                    Section(__designTimeString("#7133_8", fallback: "My Lists")) {
                        ForEach(taskManager.lists) { list in
                            ListRowView(list: list, taskManager: taskManager) {
                                editingList = list
                                listName = list.name
                                selectedIcon = list.icon
                                selectedColor = list.color // Update color when editing
                                showingEditSheet = __designTimeBoolean("#7133_9", fallback: true)
                            }
                        }
                    }
                }
                .navigationTitle(__designTimeString("#7133_10", fallback: "My Lists"))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            listName = __designTimeString("#7133_11", fallback: "")
                            selectedIcon = __designTimeString("#7133_12", fallback: "list.bullet")
                            selectedColor = colorScheme == .dark ? __designTimeString("#7133_13", fallback: "white") : __designTimeString("#7133_14", fallback: "black") // Set default color based on theme
                            showingNewListSheet = __designTimeBoolean("#7133_15", fallback: true)
                        }) {
                            Image(systemName: __designTimeString("#7133_16", fallback: "plus"))
                        }
                    }
                }
                .sheet(isPresented: $showingNewListSheet) {
                    ListEditView(
                        title: __designTimeString("#7133_17", fallback: "New List"),
                        name: $listName,
                        icon: $selectedIcon,
                        color: $selectedColor,
                        onSave: {
                            taskManager.createList(name: listName, icon: selectedIcon, color: selectedColor)
                            showingNewListSheet = __designTimeBoolean("#7133_18", fallback: false)
                        },
                        onCancel: { showingNewListSheet = __designTimeBoolean("#7133_19", fallback: false) }
                    )
                }
                .sheet(isPresented: $showingEditSheet) {
                    if let list = editingList {
                        ListEditView(
                            title: __designTimeString("#7133_20", fallback: "Edit List"),
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
                                showingEditSheet = __designTimeBoolean("#7133_21", fallback: false)
                            },
                            onCancel: { showingEditSheet = __designTimeBoolean("#7133_22", fallback: false) }
                        )
                    }
                }
                .onChange(of: showingEditSheet) { oldValue, newValue in
                    if !newValue {
                        editingList = nil
                    }
                }

                // Settings Button at Bottom Right
                VStack {
                    Spacer() // Pushes the button to the bottom
                    HStack {
                        Spacer() // Pushes the button to the right
                        Button(action: {
                            showingSettings = __designTimeBoolean("#7133_23", fallback: true)
                        }) {
                            Image(systemName: __designTimeString("#7133_24", fallback: "gear"))
                                .font(.title)
                                .padding()
                        }
                        .padding(.trailing, __designTimeInteger("#7133_25", fallback: 20))
                        .padding(.bottom, __designTimeInteger("#7133_26", fallback: 20))
                    }
                }
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }

    private var pinnedLists: [ReminderList] {
        taskManager.lists.filter { $0.isPinned }
    }

    private var unpinnedLists: [ReminderList] {
        taskManager.lists.filter { !$0.isPinned }
    }
}
