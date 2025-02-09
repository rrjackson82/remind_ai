import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/daneohr/Downloads/Xcode Projects/Reminder Roast/Reminder Roast/Reminder Roast/TodayView.swift", line: 1)
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
        .navigationTitle(__designTimeString("#12365_0", fallback: "Today"))
        .overlay {
            if taskManager.todayTasks.isEmpty {
                Text(__designTimeString("#12365_1", fallback: "No tasks due today"))
                    .foregroundColor(.gray)
            }
        }
        .sheet(item: $selectedTask) { task in
            TaskEditView(
                task: task,
                taskManager: taskManager,
                listId: task.listId,
                sectionId: task.sectionId,
                isNewTask: __designTimeBoolean("#12365_2", fallback: false)
            )
        }
    }
} 
