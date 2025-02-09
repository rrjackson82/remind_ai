//
//  TaskListView.swift
//  Reminder Roast
//
//  Created by Dane Ohr on 2/8/25.
//
import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskManager: TaskManager
    let list: ReminderList
    @State private var selectedTask: Task?
    @State private var isEditMode: EditMode = .inactive
    @State private var showingAddSection = false
    @State private var newSectionName = ""
    
    var body: some View {
        TaskListContent(
            taskManager: taskManager,
            list: list,
            selectedTask: $selectedTask,
            isEditMode: $isEditMode,
            showingAddSection: $showingAddSection,
            newSectionName: $newSectionName
        )
    }
}

struct TaskListContent: View {
    @ObservedObject var taskManager: TaskManager
    let list: ReminderList
    @Binding var selectedTask: Task?
    @Binding var isEditMode: EditMode
    @Binding var showingAddSection: Bool
    @Binding var newSectionName: String
    
    var body: some View {
        VStack {
            if taskManager.tasks[list.id]?.isEmpty ?? true {
                EmptyStateView()
            } else {
                TaskSectionsList(
                    taskManager: taskManager,
                    list: list,
                    selectedTask: $selectedTask,
                    isEditMode: isEditMode
                )
            }
        }
        .navigationTitle(list.name)
        .toolbar { TaskListToolbar(
            isEditMode: $isEditMode,
            showingAddSection: $showingAddSection,
            taskManager: taskManager,
            list: list,
            selectedTask: $selectedTask
        ) }
        .alert("New Section", isPresented: $showingAddSection) {
            NewSectionAlert(
                newSectionName: $newSectionName,
                taskManager: taskManager,
                listId: list.id,
                onAdd: {
                    isEditMode = .inactive  // Exit edit mode after adding section
                }
            )
        }
        .environment(\.editMode, $isEditMode)
        .sheet(item: $selectedTask) { task in
            TaskEditView(
                task: task,
                taskManager: taskManager,
                listId: list.id,
                sectionId: task.sectionId,
                isNewTask: task.title.isEmpty
            )
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        Text("No tasks yet").foregroundColor(.gray)
    }
}

struct TaskSectionsList: View {
    @ObservedObject var taskManager: TaskManager
    let list: ReminderList
    @Binding var selectedTask: Task?
    let isEditMode: EditMode
    @State private var isCompletedSectionExpanded = false
    
    var body: some View {
        List {
            // Active Sections
            ForEach(list.sections) { section in
                Section(header: EditableSectionHeader(
                    section: section,
                    listId: list.id,
                    taskManager: taskManager,
                    isEditMode: isEditMode
                )) {
                    if !section.isCollapsed || isEditMode == .inactive {
                        TaskList(
                            tasks: taskManager.incompleteTasks(in: section.id, listId: list.id),
                            section: section,
                            taskManager: taskManager,
                            listId: list.id,
                            selectedTask: $selectedTask,
                            isEditMode: isEditMode
                        )
                    }
                }
            }
            
            // Completed Section
            if hasCompletedTasks {
                Section {
                    if isCompletedSectionExpanded {
                        ForEach(list.sections) { section in
                            ForEach(taskManager.completedTasks(in: section.id, listId: list.id)) { task in
                                TaskRowView(task: task, listId: list.id, taskManager: taskManager)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                } header: {
                    CompletedSectionHeader(
                        isExpanded: $isCompletedSectionExpanded,
                        completedCount: completedTasksCount
                    )
                }
            }
        }
    }
    
    private var hasCompletedTasks: Bool {
        list.sections.contains { section in
            !taskManager.completedTasks(in: section.id, listId: list.id).isEmpty
        }
    }
    
    private var completedTasksCount: Int {
        list.sections.reduce(0) { count, section in
            count + taskManager.completedTasks(in: section.id, listId: list.id).count
        }
    }
}

struct TaskList: View {
    let tasks: [Task]
    let section: ListSection
    @ObservedObject var taskManager: TaskManager
    let listId: UUID
    @Binding var selectedTask: Task?
    let isEditMode: EditMode
    
    var body: some View {
        ForEach(tasks) { task in
            Group {
                if isEditMode == .active {
                    EditableTaskRow(task: task, listId: listId, taskManager: taskManager)
                } else {
                    TaskRowView(task: task, listId: listId, taskManager: taskManager)
                        .onTapGesture {
                            selectedTask = task
                        }
                }
            }
            .onDrag {
                NSItemProvider(object: task.id.uuidString as NSString)
            }
        }
        .onDelete { indexSet in
            taskManager.deleteTask(at: indexSet, from: listId, sectionId: section.id)
        }
        .onDrop(of: [.text], delegate: TaskDropDelegate(
            taskManager: taskManager,
            listId: listId,
            destinationSection: section
        ))
    }
}

struct TaskListToolbar: ToolbarContent {
    @Binding var isEditMode: EditMode
    @Binding var showingAddSection: Bool
    @ObservedObject var taskManager: TaskManager
    let list: ReminderList
    @Binding var selectedTask: Task?
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
                if isEditMode == .active {
                    Button("Add Section") {
                        showingAddSection = true
                    }
                }
                Button(isEditMode == .active ? "Done" : "Edit") {
                    isEditMode = isEditMode == .active ? .inactive : .active
                }
                if isEditMode == .inactive {
                    AddTaskButton(
                        list: list,
                        selectedTask: $selectedTask
                    )
                }
            }
        }
    }
}

struct AddTaskButton: View {
    let list: ReminderList
    @Binding var selectedTask: Task?
    
    var body: some View {
        Button(action: {
            let defaultSection = list.sections.first ?? ListSection(name: "Default")
            selectedTask = Task(
                title: "",
                dueDate: Date().roundedToNextHour(),
                sectionId: defaultSection.id,
                listId: list.id
            )
        }) {
            Image(systemName: "plus")
        }
    }
}

struct NewSectionAlert: View {
    @Binding var newSectionName: String
    let taskManager: TaskManager
    let listId: UUID
    let onAdd: () -> Void
    
    var body: some View {
        TextField("Section Name", text: $newSectionName)
        Button("Cancel", role: .cancel) {
            newSectionName = ""
        }
        Button("Add") {
            if !newSectionName.isEmpty {
                taskManager.addSection(newSectionName, to: listId)
                newSectionName = ""
                onAdd()  // Call the callback to exit edit mode
            }
        }
    }
}

struct EditableSectionHeader: View {
    let section: ListSection
    let listId: UUID
    @ObservedObject var taskManager: TaskManager
    let isEditMode: EditMode
    @State private var editedName: String
    @State private var showingNewTaskSheet = false
    
    init(section: ListSection, listId: UUID, taskManager: TaskManager, isEditMode: EditMode) {
        self.section = section
        self.listId = listId
        self.taskManager = taskManager
        self.isEditMode = isEditMode
        self._editedName = State(initialValue: section.name)
    }
    
    var body: some View {
        Group {
            if isEditMode == .active {
                Button(action: { 
                    taskManager.toggleSectionCollapsed(section.id, in: listId)
                }) {
                    HStack {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.gray)
                            .frame(width: 24)
                        
                        TextField("Section Name", text: $editedName)
                            .onChange(of: editedName) { _, _ in
                                let updatedSection = ListSection(id: section.id, name: editedName)
                                taskManager.updateSection(updatedSection, in: listId)
                            }
                        
                        Spacer()
                        
                        Image(systemName: section.isCollapsed ? "chevron.right" : "chevron.down")
                            .foregroundColor(.gray)
                            .frame(width: 24)
                        
                        Button(role: .destructive) {
                            withAnimation {
                                taskManager.deleteSection(section.id, from: listId)
                            }
                        } label: {
                            Image(systemName: "minus.circle.fill")
                                .foregroundColor(.red)
                                .frame(width: 24)
                        }
                    }
                    .padding(.vertical, 6)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .contentShape(Rectangle())
                }
            } else {
                HStack {
                    Text(section.name)
                        .font(.system(.subheadline, weight: .semibold))
                        .foregroundColor(.secondary)
                    Spacer()
                    Button(action: {
                        showingNewTaskSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .sheet(isPresented: $showingNewTaskSheet) {
            TaskEditView(
                task: Task(
                    title: "",
                    dueDate: Date().roundedToNextHour(),
                    sectionId: section.id,
                    listId: listId
                ),
                taskManager: taskManager,
                listId: listId,
                sectionId: section.id,
                isNewTask: true
            )
        }
    }
}

// New EditableTaskRow for edit mode
struct EditableTaskRow: View {
    let task: Task
    let listId: UUID
    @ObservedObject var taskManager: TaskManager
    @State private var title: String
    @State private var description: String
    @State private var dueDate: Date
    @State private var showDatePicker = false
    
    init(task: Task, listId: UUID, taskManager: TaskManager) {
        self.task = task
        self.listId = listId
        self.taskManager = taskManager
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description ?? "")
        _dueDate = State(initialValue: task.dueDate)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.gray)
                    .frame(width: 24)
                
                TextField("Title", text: $title, onEditingChanged: { _ in })
                    .onChange(of: title) { _, _ in
                        updateTask()
                    }
            }
            
            if !description.isEmpty {
                TextField("Description", text: $description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .onChange(of: description) { _, _ in
                        updateTask()
                    }
                    .padding(.leading, 28)
            }
            
            HStack {
                Text(formatDate(dueDate))
                    .font(.subheadline)
                    .foregroundColor(.blue)
                
                Button(action: { showDatePicker.toggle() }) {
                    Image(systemName: "calendar")
                        .foregroundColor(.blue)
                }
            }
            .padding(.leading, 28)
            
            if showDatePicker {
                DatePicker("", selection: $dueDate)
                    .datePickerStyle(.graphical)
                    .onChange(of: dueDate) { _, _ in
                        updateTask()
                        showDatePicker = false
                    }
            }
        }
        .padding(.vertical, 4)
        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                // Find the task in the correct section and delete it
                let sectionId = task.sectionId
                if let sectionTasks = taskManager.tasks[listId]?[sectionId],
                   let index = sectionTasks.firstIndex(where: { $0.id == task.id }) {
                    taskManager.deleteTask(at: IndexSet([index]), from: listId, sectionId: sectionId)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
    
    private func updateTask() {
        let updatedTask = Task(
            id: task.id,
            title: title,
            description: description.isEmpty ? nil : description,
            dueDate: dueDate,
            isCompleted: task.isCompleted,
            sectionId: task.sectionId,
            listId: listId
        )
        taskManager.updateTask(updatedTask, in: listId)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Keep existing TaskRowView for non-edit mode
struct TaskRowView: View {
    let task: Task
    let listId: UUID
    @ObservedObject var taskManager: TaskManager
    
    var isPastDue: Bool {
        !task.isCompleted && task.dueDate < Date()
    }
    
    var body: some View {
        HStack {
            // Completion Circle Button
            Button(action: {
                withAnimation {
                    taskManager.toggleTaskCompletion(taskId: task.id, in: listId)
                }
            }) {
                ZStack {
                    Circle()
                        .strokeBorder(task.isCompleted ? .green : .blue, lineWidth: 2)
                        .frame(width: 24, height: 24)
                    
                    if task.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 24))
                    }
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(task.title)
                        .font(.headline)
                        .strikethrough(task.isCompleted)
                    Spacer()
                }
                
                Text(formatDate(task.dueDate))
                    .font(.subheadline)
                    .foregroundColor(isPastDue ? .red : .gray)
                
                if let description = task.description {
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct TaskDropDelegate: DropDelegate {
    let taskManager: TaskManager
    let listId: UUID
    let destinationSection: ListSection
    
    func performDrop(info: DropInfo) -> Bool {
        guard let itemProvider = info.itemProviders(for: [.text]).first else { return false }
        
        itemProvider.loadObject(ofClass: NSString.self) { (taskIdString, error) in
            if let taskIdString = taskIdString as? String,
               let taskId = UUID(uuidString: taskIdString) {
                DispatchQueue.main.async {
                    taskManager.moveTaskToSection(taskId: taskId, to: destinationSection.id, in: listId)
                }
            }
        }
        return true
    }
    
    func dropEntered(info: DropInfo) {
        // Add visual feedback here if desired
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
}

struct CompletedSectionHeader: View {
    @Binding var isExpanded: Bool
    let completedCount: Int
    
    var body: some View {
        HStack {
            Text("Completed (\(completedCount))")
            Spacer()
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .foregroundColor(.gray)
            }
        }
    }
}

extension Date {
    func roundedToNextHour() -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour], from: self)
        
        // Add 1 hour and set minutes/seconds to 0
        components.hour! += 1
        components.minute = 0
        components.second = 0
        
        return calendar.date(from: components) ?? self
    }
}
