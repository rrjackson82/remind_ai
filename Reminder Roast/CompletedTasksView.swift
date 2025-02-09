import SwiftUI

struct CompletedTasksView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var selectedTask: Task?
    @State private var showingClearConfirmation = false
    
    var body: some View {
        List {
            ForEach(taskManager.tasksGroupedByList(completed: true), id: \.0) { listName, tasks in
                Section(header: Text(listName)) {
                    ForEach(tasks) { task in
                        TaskRowView(task: task, listId: task.listId, taskManager: taskManager)
                            .foregroundColor(.gray)
                            .onTapGesture {
                                selectedTask = task
                            }
                    }
                }
            }
        }
        .navigationTitle("Completed")
        .toolbar {
            if !taskManager.allCompletedTasks.isEmpty {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear All") {
                        showingClearConfirmation = true
                    }
                    .foregroundColor(.red)
                }
            }
        }
        .alert("Clear Completed Tasks", isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear All", role: .destructive) {
                taskManager.clearCompletedTasks()
            }
        } message: {
            Text("Are you sure you want to permanently delete all completed tasks?")
        }
        .sheet(item: $selectedTask) { task in
            TaskEditView(
                task: task,
                taskManager: taskManager,
                listId: task.listId,
                sectionId: task.sectionId,
                isNewTask: false
            )
        }
        .overlay {
            if taskManager.allCompletedTasks.isEmpty {
                Text("No completed tasks")
                    .foregroundColor(.gray)
            }
        }
    }
} 