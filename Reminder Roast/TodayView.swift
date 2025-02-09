import SwiftUI

struct TodayView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var selectedTask: Task?
    
    var body: some View {
        List {
            ForEach(taskManager.todayTasks) { task in
                TaskRowView(task: task, listId: task.listId, taskManager: taskManager)
                    .onTapGesture {
                        selectedTask = task
                    }
            }
        }
        .navigationTitle("Today")
        .overlay {
            if taskManager.todayTasks.isEmpty {
                Text("No tasks due today")
                    .foregroundColor(.gray)
            }
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
    }
} 