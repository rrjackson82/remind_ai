import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/daneohr/Downloads/Xcode Projects/Reminder Roast/Reminder Roast/Reminder Roast/TaskEditView.swift", line: 1)
import SwiftUI

struct TaskEditView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var taskManager: TaskManager
    
    @State private var title: String
    @State private var description: String
    @State private var dueDate: Date
    @State private var effortLevel: Int
    
    let task: Task
    let isNewTask: Bool
    
    init(task: Task, taskManager: TaskManager, isNewTask: Bool = false) {
        self.task = task
        self.taskManager = taskManager
        self.isNewTask = isNewTask
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description ?? "")
        _dueDate = State(initialValue: task.dueDate)
        _effortLevel = State(initialValue: task.effortLevel)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(__designTimeString("#8944_0", fallback: "Task Details"))) {
                    TextField(__designTimeString("#8944_1", fallback: "Title"), text: $title)
                    TextField(__designTimeString("#8944_2", fallback: "Description"), text: $description)
                }
                
                Section(header: Text(__designTimeString("#8944_3", fallback: "Due Date"))) {
                    DatePicker(__designTimeString("#8944_4", fallback: "Due Date"), selection: $dueDate)
                }
                
                Section(header: Text(__designTimeString("#8944_5", fallback: "Effort Level (1-5)"))) {
                    Stepper("Effort: \(effortLevel)", value: $effortLevel, in: __designTimeInteger("#8944_6", fallback: 1)...__designTimeInteger("#8944_7", fallback: 5))
                }
            }
            .navigationTitle(isNewTask ? __designTimeString("#8944_8", fallback: "New Task") : __designTimeString("#8944_9", fallback: "Edit Task"))
            .navigationBarItems(
                leading: Button(__designTimeString("#8944_10", fallback: "Cancel")) {
                    dismiss()
                },
                trailing: Button(__designTimeString("#8944_11", fallback: "Save")) {
                    saveTask()
                }
                .disabled(title.isEmpty)
            )
        }
    }
    
    private func saveTask() {
        let updatedTask = Task(
            id: task.id,
            title: title,
            description: description.isEmpty ? nil : description,
            dueDate: dueDate,
            isCompleted: task.isCompleted,
            effortLevel: effortLevel
        )
        
        if isNewTask {
            taskManager.addTask(updatedTask)
        } else {
            taskManager.updateTask(updatedTask)
        }
        dismiss()
    }
}
