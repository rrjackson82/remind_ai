import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/daneohr/Downloads/Xcode Projects/Reminder Roast/Reminder Roast/Reminder Roast/TaskEditView.swift", line: 1)
import SwiftUI

struct TaskEditView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var taskManager: TaskManager
    let listId: UUID
    
    @State private var title: String
    @State private var description: String
    @State private var dueDate: Date
    @State private var selectedSectionId: UUID
    
    let task: Task
    let isNewTask: Bool
    
    init(task: Task, taskManager: TaskManager, listId: UUID, sectionId: UUID, isNewTask: Bool = false) {
        self.task = task
        self.taskManager = taskManager
        self.listId = listId
        self._title = State(initialValue: task.title)
        self._description = State(initialValue: task.description ?? "")
        self._dueDate = State(initialValue: task.dueDate)
        self._selectedSectionId = State(initialValue: sectionId)
        self.isNewTask = isNewTask
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(__designTimeString("#8944_0", fallback: "Task Details"))) {
                    TextField(__designTimeString("#8944_1", fallback: "Title"), text: $title)
                    TextField(__designTimeString("#8944_2", fallback: "Description"), text: $description)
                }
                
                Section(header: Text(__designTimeString("#8944_3", fallback: "Section"))) {
                    if let list = taskManager.lists.first(where: { $0.id == listId }) {
                        Picker(__designTimeString("#8944_4", fallback: "Section"), selection: $selectedSectionId) {
                            ForEach(list.sections) { section in
                                Text(section.name)
                                    .tag(section.id)
                            }
                        }
                    }
                }
                
                Section(header: Text(__designTimeString("#8944_5", fallback: "Due Date"))) {
                    DatePicker(__designTimeString("#8944_6", fallback: "Due Date"), selection: $dueDate)
                }
            }
            .navigationTitle(isNewTask ? __designTimeString("#8944_7", fallback: "New Task") : __designTimeString("#8944_8", fallback: "Edit Task"))
            .navigationBarItems(
                leading: Button(__designTimeString("#8944_9", fallback: "Cancel")) {
                    dismiss()
                },
                trailing: Button(__designTimeString("#8944_10", fallback: "Save")) {
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
            sectionId: selectedSectionId,
            listId: listId
        )
        
        if isNewTask {
            taskManager.addTask(updatedTask, to: listId)
        } else {
            taskManager.updateTask(updatedTask, in: listId)
        }
        dismiss()
    }
}
