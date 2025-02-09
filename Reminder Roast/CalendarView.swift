import SwiftUI

struct CalendarView: View {
    @ObservedObject var taskManager: TaskManager
    @State private var selectedDate: Date = Date()
    @State private var selectedTask: Task?
    @State private var dragOffset = CGSize.zero
    @State private var isAnimating = false
    
    private let calendar = Calendar.current
    private let daysInWeek = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Month header with side arrows
            HStack {
                Button(action: {
                    withAnimation {
                        selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
                
                Spacer()
                
                VStack {
                    Text(monthYearString(from: selectedDate))
                        .font(.title3.bold())
                        .animation(.none, value: selectedDate)
                        .id(monthYearString(from: selectedDate))
                    
                    Button("Today") {
                        withAnimation {
                            selectedDate = Date()
                        }
                    }
                    .font(.caption)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                    }
                }) {
                    Image(systemName: "chevron.right")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
            }
            .padding(.top, 8)
            
            // Days of week header
            HStack(spacing: 0) {
                ForEach(daysInWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 4)
            
            // Calendar grid
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    ForEach(-1...1, id: \.self) { offset in
                        MonthView(
                            date: calendar.date(byAdding: .month, value: offset, to: selectedDate) ?? selectedDate,
                            selectedDate: $selectedDate,
                            taskManager: taskManager,
                            width: geometry.size.width
                        )
                    }
                }
                .offset(x: -geometry.size.width + dragOffset.width)
                .animation(.none, value: selectedDate)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if !isAnimating {
                                dragOffset = gesture.translation
                            }
                        }
                        .onEnded { gesture in
                            let threshold: CGFloat = 50
                            isAnimating = true
                            
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                if gesture.translation.width > threshold {
                                    selectedDate = calendar.date(byAdding: .month, value: -1, to: selectedDate) ?? selectedDate
                                    dragOffset = CGSize(width: geometry.size.width, height: 0)
                                } else if gesture.translation.width < -threshold {
                                    selectedDate = calendar.date(byAdding: .month, value: 1, to: selectedDate) ?? selectedDate
                                    dragOffset = CGSize(width: -geometry.size.width, height: 0)
                                } else {
                                    dragOffset = .zero
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.none) {
                                    dragOffset = .zero
                                    isAnimating = false
                                }
                            }
                        }
                )
            }
            .frame(height: 240)
            
            Divider()
            
            // Selected date header
            HStack {
                Text(formatSelectedDate(selectedDate))
                    .font(.headline)
                Spacer()
            }
            .padding()
            
            // Tasks list with completed tasks
            List {
                let tasks = taskManager.tasksForDate(selectedDate)
                if tasks.isEmpty {
                    Text("No Events")
                        .foregroundColor(.gray)
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.clear)
                } else {
                    // Incomplete tasks
                    ForEach(taskManager.tasksGroupedByList(forDate: selectedDate, completed: false), id: \.0) { listName, tasks in
                        Section(header: Text(listName)) {
                            ForEach(tasks) { task in
                                TaskRowView(task: task, listId: task.listId, taskManager: taskManager)
                                    .onTapGesture {
                                        selectedTask = task
                                    }
                            }
                        }
                    }
                    
                    // Completed tasks
                    let completedTasks = taskManager.tasksGroupedByList(forDate: selectedDate, completed: true)
                    if !completedTasks.isEmpty {
                        Section(header: Text("Completed")) {
                            ForEach(completedTasks, id: \.0) { listName, tasks in
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
                }
            }
            .listStyle(.insetGrouped)
        }
        .navigationBarTitleDisplayMode(.inline)
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
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func formatSelectedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: date)
    }
}

struct MonthView: View {
    let date: Date
    @Binding var selectedDate: Date
    @ObservedObject var taskManager: TaskManager
    let width: CGFloat
    private let calendar = Calendar.current
    
    var body: some View {
        let days = daysInMonth()
        let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
        
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(0..<days.count, id: \.self) { index in
                if let date = days[index] {
                    DayCell(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        events: taskManager.tasksForDate(date),
                        isToday: calendar.isDateInToday(date),
                        isCurrentMonth: calendar.isDate(date, equalTo: self.date, toGranularity: .month)
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedDate = date
                        }
                    }
                } else {
                    Color.clear
                }
            }
        }
        .frame(width: width)
    }
    
    private func daysInMonth() -> [Date?] {
        let start = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let range = calendar.range(of: .day, in: .month, for: start)!
        let firstWeekday = calendar.component(.weekday, from: start)
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - 1)
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: start) {
                days.append(date)
            }
        }
        
        while days.count % 7 != 0 {
            days.append(nil)
        }
        
        return days
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let events: [Task]
    let isToday: Bool
    let isCurrentMonth: Bool
    
    private let calendar = Calendar.current
    private let cellSize: CGFloat = 32
    
    var body: some View {
        VStack(spacing: 4) {
            if isToday {
                Text("\(calendar.component(.day, from: date))")
                    .font(.callout)
                    .foregroundColor(.white)
                    .frame(width: cellSize, height: cellSize)
                    .background(Circle().fill(Color.red))
            } else {
                Text("\(calendar.component(.day, from: date))")
                    .font(.callout)
                    .foregroundColor(isCurrentMonth ? (isSelected ? .blue : .primary) : .gray)
                    .frame(width: cellSize, height: cellSize)
                    .background(
                        Circle()
                            .fill(isSelected ? Color.blue.opacity(0.2) : Color.clear)
                    )
            }
            
            if !events.isEmpty {
                HStack(spacing: 4) {
                    let incompleteTasks = events.filter { !$0.isCompleted }.prefix(2)
                    let completedTasks = events.filter { $0.isCompleted }.prefix(2)
                    
                    // Show incomplete tasks dots
                    ForEach(Array(incompleteTasks.enumerated()), id: \.1.id) { _, task in
                        Circle()
                            .fill(colorForList(task.listId))
                            .frame(width: 4, height: 4)
                    }
                    
                    // Show completed tasks dots in gray
                    ForEach(Array(completedTasks.enumerated()), id: \.1.id) { _, task in
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 4, height: 4)
                    }
                    
                    // If there are more tasks than we can show dots for
                    if events.count > 4 {
                        Text("•")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .frame(height: 45)
    }
    
    private func colorForList(_ listId: UUID) -> Color {
        // Get the list color from TaskManager
        // For now, return a default color
        .blue
    }
} 