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
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                }
                
                Section(header: Text("Section")) {
                    if let list = taskManager.lists.first(where: { $0.id == listId }) {
                        Picker("Section", selection: $selectedSectionId) {
                            ForEach(list.sections) { section in
                                Text(section.name)
                                    .tag(section.id)
                            }
                        }
                    }
                }
                
                Section(header: Text("Due Date")) {
                    DatePicker("Due Date", selection: $dueDate)
                }
            }
            .navigationTitle(isNewTask ? "New Task" : "Edit Task")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
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
