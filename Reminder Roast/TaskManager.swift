import Foundation
import SwiftUI

class TaskManager: ObservableObject {
    
    @Published private(set) var lists: [ReminderList] = []
    @Published private(set) var tasks: [UUID: [UUID: [Task]]] = [:] // [ListID: [SectionID: [Task]]]
    
    private let userDefaultsKey = "savedTasks"
    private let listsDefaultsKey = "savedLists"
    
    init() {
        loadLists()
        loadTasks()
        if lists.isEmpty {
            createDefaultLists()
        }
    }
    
    // MARK: - List Management
    
    func createList(name: String, icon: String, color: String, isPinned: Bool = false) {
        let newList = ReminderList(name: name, icon: icon, color: color, isPinned: isPinned)
        lists.append(newList)
        tasks[newList.id] = [:]
        saveLists()
    }
    
    func deleteList(_ listId: UUID) {
        lists.removeAll { $0.id == listId }
        tasks.removeValue(forKey: listId)
        saveLists()
        saveTasks()
    }
    
    func updateList(_ list: ReminderList) {
        if let index = lists.firstIndex(where: { $0.id == list.id }) {
            lists[index] = list
            saveLists()
        }
    }
    
    // MARK: - Task Management
    
    // Add Task function where notification is scheduled
    func addTask(_ task: Task, to listId: UUID) {
        if tasks[listId] == nil {
            tasks[listId] = [:]
        }
        if tasks[listId]?[task.sectionId] == nil {
            tasks[listId]?[task.sectionId] = []
        }
        tasks[listId]?[task.sectionId]?.append(task)
        sortTasks(in: listId)
        saveTasks()

        // Directly use task.dueDate (since it's non-optional)
        NotificationManager.shared.scheduleNotification(
            title: task.title,
            body: task.description ?? "No description provided",
            date: task.dueDate,
            id: task.id  // Pass task ID so we can remove it later
        )
    }
    
    func deleteTask(at indexSet: IndexSet, from listId: UUID, sectionId: UUID) {
        if var sectionTasks = tasks[listId]?[sectionId] {
            for index in indexSet {
                let taskToDelete = sectionTasks[index]
                
                // Cancel notification before deleting the task
                NotificationManager.shared.cancelNotification(for: taskToDelete.id)
            }
            
            sectionTasks.remove(atOffsets: indexSet)
            tasks[listId]?[sectionId] = sectionTasks
            saveTasks()
        }
    }
    
    func updateTask(_ updatedTask: Task, in listId: UUID) {
        if let index = tasks[listId]?[updatedTask.sectionId]?.firstIndex(where: { $0.id == updatedTask.id }) {
            let oldTask = tasks[listId]?[updatedTask.sectionId]?[index]  // Store old task details
            
            tasks[listId]?[updatedTask.sectionId]?[index] = updatedTask
            sortTasks(in: listId)
            saveTasks()
            
            NotificationManager.shared.cancelNotification(for: updatedTask.id)

            NotificationManager.shared.scheduleNotification(
                title: updatedTask.title,
                body: updatedTask.description ?? "No description provided",
                date: updatedTask.dueDate,
                id: updatedTask.id
            )
        }
    }
    
    func toggleTaskCompletion(taskId: UUID, in listId: UUID) {
        for (sectionId, sectionTasks) in tasks[listId] ?? [:] {
            if let index = sectionTasks.firstIndex(where: { $0.id == taskId }) {
                var task = sectionTasks[index]
                task.isCompleted.toggle()
                tasks[listId]?[sectionId]?[index] = task
                sortTasks(in: listId)
                saveTasks()
                break
            }
        }
    }
    
    // MARK: - Section Management
    
    func addSection(_ name: String, to listId: UUID) {
        if let index = lists.firstIndex(where: { $0.id == listId }) {
            let newSection = ListSection(name: name)
            lists[index].sections.append(newSection)
            tasks[listId, default: [:]][newSection.id] = []
            saveLists()
            saveTasks()
        }
    }
    
    func deleteSection(_ sectionId: UUID, from listId: UUID) {
        if let listIndex = lists.firstIndex(where: { $0.id == listId }) {
            lists[listIndex].sections.removeAll { $0.id == sectionId }
            tasks[listId]?.removeValue(forKey: sectionId)
            saveLists()
            saveTasks()
        }
    }
    
    func updateSection(_ section: ListSection, in listId: UUID) {
        if let listIndex = lists.firstIndex(where: { $0.id == listId }),
           let sectionIndex = lists[listIndex].sections.firstIndex(where: { $0.id == section.id }) {
            // Preserve the collapsed state when updating
            let updatedSection = ListSection(
                id: section.id,
                name: section.name,
                isCollapsed: lists[listIndex].sections[sectionIndex].isCollapsed
            )
            lists[listIndex].sections[sectionIndex] = updatedSection
            saveLists()
        }
    }
    
    func toggleSectionCollapsed(_ sectionId: UUID, in listId: UUID) {
        if let listIndex = lists.firstIndex(where: { $0.id == listId }),
           let sectionIndex = lists[listIndex].sections.firstIndex(where: { $0.id == sectionId }) {
            lists[listIndex].sections[sectionIndex].isCollapsed.toggle()
            saveLists()
        }
    }
    
    func moveTask(_ task: Task, from sourceSection: UUID, to destinationSection: UUID, in listId: UUID) {
        if var listTasks = tasks[listId] {
            // Remove from source section
            listTasks[sourceSection]?.removeAll { $0.id == task.id }
            // Add to destination section
            listTasks[destinationSection, default: []].append(task)
            tasks[listId] = listTasks
            saveTasks()
        }
    }
    
    func tasksInSection(_ sectionId: UUID, in listId: UUID) -> [Task] {
        return tasks[listId]?[sectionId] ?? []
    }
    
    func incompleteTasks(in sectionId: UUID, listId: UUID) -> [Task] {
        return tasksInSection(sectionId, in: listId).filter { !$0.isCompleted }
    }
    
    func completedTasks(in sectionId: UUID, listId: UUID) -> [Task] {
        return tasksInSection(sectionId, in: listId).filter { $0.isCompleted }
    }
    
    // MARK: - Persistence
    
    private func createDefaultLists() {
        createList(name: "Personal", icon: "person", color: "blue")
        createList(name: "Work", icon: "briefcase", color: "red")
        createList(name: "Shopping", icon: "cart", color: "green")
    }
    
    private func saveLists() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(lists)
            UserDefaults.standard.set(data, forKey: listsDefaultsKey)
        } catch {
            print("Error saving lists: \(error.localizedDescription)")
        }
    }
    
    private func loadLists() {
        guard let data = UserDefaults.standard.data(forKey: listsDefaultsKey) else { return }
        
        do {
            let decoder = JSONDecoder()
            lists = try decoder.decode([ReminderList].self, from: data)
        } catch {
            print("Error loading lists: \(error.localizedDescription)")
        }
    }
    
    private func saveTasks() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(tasks)
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        } catch {
            print("Error saving tasks: \(error.localizedDescription)")
        }
    }
    
    private func loadTasks() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return }
        
        do {
            let decoder = JSONDecoder()
            tasks = try decoder.decode([UUID: [UUID: [Task]]].self, from: data)
        } catch {
            print("Error loading tasks: \(error.localizedDescription)")
        }
    }
    
    private func sortTasks(in listId: UUID) {
        for (sectionId, sectionTasks) in tasks[listId] ?? [:] {
            let sortedTasks = sectionTasks.sorted { $0.dueDate < $1.dueDate }
            tasks[listId]?[sectionId] = sortedTasks
        }
    }
    
    func moveTaskToSection(taskId: UUID, to destinationSectionId: UUID, in listId: UUID) {
        guard var listTasks = tasks[listId] else { return }
        
        // Find the source section and task
        for (sourceSectionId, sectionTasks) in listTasks {
            if let taskIndex = sectionTasks.firstIndex(where: { $0.id == taskId }) {
                var task = sectionTasks[taskIndex]
                
                // Remove from source section
                listTasks[sourceSectionId]?.remove(at: taskIndex)
                
                // Update task's section ID
                task.sectionId = destinationSectionId
                
                // Add to destination section
                listTasks[destinationSectionId, default: []].append(task)
                
                // Update the tasks dictionary
                tasks[listId] = listTasks
                saveTasks()
                break
            }
        }
    }
    
    // Add computed properties for special lists
    var allTasks: [Task] {
        tasks.flatMap { (listId, sectionTasks) in
            sectionTasks.flatMap { (_, tasks) in
                tasks.filter { !$0.isCompleted }
            }
        }
    }
    
    var allCompletedTasks: [Task] {
        tasks.flatMap { (listId, sectionTasks) in
            sectionTasks.flatMap { (_, tasks) in
                tasks.filter { $0.isCompleted }
            }
        }
    }
    
    // Add method to get list name for a task
    func getListName(for taskId: UUID) -> String {
        for (listId, sectionTasks) in tasks {
            for (_, tasks) in sectionTasks {
                if tasks.contains(where: { $0.id == taskId }) {
                    return lists.first(where: { $0.id == listId })?.name ?? "Unknown List"
                }
            }
        }
        return "Unknown List"
    }
    
    // Add method to get today's tasks
    var todayTasks: [Task] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
        
        return tasks.flatMap { (listId, sectionTasks) in
            sectionTasks.flatMap { (_, tasks) in
                tasks.filter { task in
                    !task.isCompleted &&
                    task.dueDate >= today &&
                    task.dueDate < tomorrow
                }
            }
        }
    }
    
    // Add back the original tasksGroupedByList function
    func tasksGroupedByList(completed: Bool = false) -> [(String, [Task])] {
        var groupedTasks: [(String, [Task])] = []
        
        for list in lists {
            let listTasks = tasks[list.id]?.values
                .flatMap { $0 }
                .filter { $0.isCompleted == completed } ?? []
            
            if !listTasks.isEmpty {
                groupedTasks.append((list.name, listTasks))
            }
        }
        
        return groupedTasks
    }
    
    // Keep the new date-specific version
    func tasksGroupedByList(forDate date: Date, completed: Bool = false) -> [(String, [Task])] {
        let calendar = Calendar.current
        var groupedTasks: [(String, [Task])] = []
        
        for list in lists {
            let listTasks = tasks[list.id]?.values
                .flatMap { $0 }
                .filter { task in 
                    calendar.isDate(task.dueDate, inSameDayAs: date) &&
                    task.isCompleted == completed
                }
                .sorted { $0.dueDate < $1.dueDate } ?? []
            
            if !listTasks.isEmpty {
                groupedTasks.append((list.name, listTasks))
            }
        }
        
        return groupedTasks
    }
    
    func togglePinList(_ listId: UUID) {
        if let index = lists.firstIndex(where: { $0.id == listId }) {
            lists[index].isPinned.toggle()
            saveLists()
        }
    }
    
    func hasTasksForDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        return tasks.values.contains { sectionTasks in
            sectionTasks.values.contains { tasks in
                tasks.contains { task in
                    calendar.isDate(task.dueDate, inSameDayAs: date)
                }
            }
        }
    }
    
    func tasksForDate(_ date: Date) -> [Task] {
        let calendar = Calendar.current
        return tasks.flatMap { (_, sectionTasks) in
            sectionTasks.flatMap { (_, tasks) in
                tasks.filter { task in
                    calendar.isDate(task.dueDate, inSameDayAs: date)
                }
            }
        }
        .sorted { $0.dueDate < $1.dueDate }
    }
    
    func clearCompletedTasks() {
        for (listId, sectionTasks) in tasks {
            for (sectionId, tasks) in sectionTasks {
                let incompleteTasks = tasks.filter { !$0.isCompleted }
                self.tasks[listId]?[sectionId] = incompleteTasks
            }
        }
        saveTasks()
    }
} 
