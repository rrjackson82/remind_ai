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

                    Section("My Lists") {
                        ForEach(taskManager.lists) { list in
                            ListRowView(list: list, taskManager: taskManager) {
                                editingList = list
                                listName = list.name
                                selectedIcon = list.icon
                                selectedColor = list.color // Update color when editing
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
                            selectedColor = colorScheme == .dark ? "white" : "black" // Set default color based on theme
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

                // Settings Button at Bottom Right
                VStack {
                    Spacer() // Pushes the button to the bottom
                    HStack {
                        Spacer() // Pushes the button to the right
                        Button(action: {
                            showingSettings = true
                        }) {
                            Image(systemName: "gear")
                                .font(.title)
                                .padding()
                        }
                        .padding(.trailing, 20)
                        .padding(.bottom, 20)
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
