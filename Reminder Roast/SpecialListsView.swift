import SwiftUI

struct AllTasksView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var selectedTask: Task?
    
    var body: some View {
        List {
            ForEach(taskManager.tasksGroupedByList(), id: \.0) { listName, tasks in
                Section(header: Text(listName)) {
                    ForEach(tasks) { task in
                        TaskRowView(task: task, listId: task.listId, taskManager: taskManager)
                            .onTapGesture {
                                selectedTask = task
                            }
                    }
                }
            }
        }
        .navigationTitle("All Tasks")
        .sheet(item: $selectedTask) { task in
            TaskEditView(
                task: task,
                taskManager: taskManager,
                listId: task.listId,
                sectionId: task.sectionId,
                isNewTask: false
            )
        }
    }
} 