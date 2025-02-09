import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/daneohr/Downloads/Xcode Projects/Reminder Roast/Reminder Roast/Reminder Roast/CalendarView.swift", line: 1)
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
        VStack(spacing: __designTimeInteger("#12338_0", fallback: 0)) {
            // Month header with side arrows
            HStack {
                Button(action: {
                    withAnimation {
                        selectedDate = calendar.date(byAdding: .month, value: __designTimeInteger("#12338_1", fallback: -1), to: selectedDate) ?? selectedDate
                    }
                }) {
                    Image(systemName: __designTimeString("#12338_2", fallback: "chevron.left"))
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
                    
                    Button(__designTimeString("#12338_3", fallback: "Today")) {
                        withAnimation {
                            selectedDate = Date()
                        }
                    }
                    .font(.caption)
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        selectedDate = calendar.date(byAdding: .month, value: __designTimeInteger("#12338_4", fallback: 1), to: selectedDate) ?? selectedDate
                    }
                }) {
                    Image(systemName: __designTimeString("#12338_5", fallback: "chevron.right"))
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal)
            }
            .padding(.top, __designTimeInteger("#12338_6", fallback: 8))
            
            // Days of week header
            HStack(spacing: __designTimeInteger("#12338_7", fallback: 0)) {
                ForEach(daysInWeek, id: \.self) { day in
                    Text(day)
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, __designTimeInteger("#12338_8", fallback: 4))
            
            // Calendar grid
            GeometryReader { geometry in
                HStack(spacing: __designTimeInteger("#12338_9", fallback: 0)) {
                    ForEach(__designTimeInteger("#12338_10", fallback: -1)...__designTimeInteger("#12338_11", fallback: 1), id: \.self) { offset in
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
                            let threshold: CGFloat = __designTimeInteger("#12338_12", fallback: 50)
                            isAnimating = __designTimeBoolean("#12338_13", fallback: true)
                            
                            withAnimation(.spring(response: __designTimeFloat("#12338_14", fallback: 0.3), dampingFraction: __designTimeFloat("#12338_15", fallback: 0.8))) {
                                if gesture.translation.width > threshold {
                                    selectedDate = calendar.date(byAdding: .month, value: __designTimeInteger("#12338_16", fallback: -1), to: selectedDate) ?? selectedDate
                                    dragOffset = CGSize(width: geometry.size.width, height: __designTimeInteger("#12338_17", fallback: 0))
                                } else if gesture.translation.width < -threshold {
                                    selectedDate = calendar.date(byAdding: .month, value: __designTimeInteger("#12338_18", fallback: 1), to: selectedDate) ?? selectedDate
                                    dragOffset = CGSize(width: -geometry.size.width, height: __designTimeInteger("#12338_19", fallback: 0))
                                } else {
                                    dragOffset = .zero
                                }
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + __designTimeFloat("#12338_20", fallback: 0.3)) {
                                withAnimation(.none) {
                                    dragOffset = .zero
                                    isAnimating = __designTimeBoolean("#12338_21", fallback: false)
                                }
                            }
                        }
                )
            }
            .frame(height: __designTimeInteger("#12338_22", fallback: 240))
            
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
                    Text(__designTimeString("#12338_23", fallback: "No Events"))
                        .foregroundColor(.gray)
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.clear)
                } else {
                    // Incomplete tasks
                    ForEach(taskManager.tasksGroupedByList(forDate: selectedDate, completed: __designTimeBoolean("#12338_24", fallback: false)), id: \.0) { listName, tasks in
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
                    let completedTasks = taskManager.tasksGroupedByList(forDate: selectedDate, completed: __designTimeBoolean("#12338_25", fallback: true))
                    if !completedTasks.isEmpty {
                        Section(header: Text(__designTimeString("#12338_26", fallback: "Completed"))) {
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
                isNewTask: __designTimeBoolean("#12338_27", fallback: false)
            )
        }
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = __designTimeString("#12338_28", fallback: "MMMM yyyy")
        return formatter.string(from: date)
    }
    
    private func formatSelectedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = __designTimeString("#12338_29", fallback: "EEEE, MMMM d, yyyy")
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
        let columns = Array(repeating: GridItem(.flexible(), spacing: __designTimeInteger("#12338_30", fallback: 0)), count: __designTimeInteger("#12338_31", fallback: 7))
        
        LazyVGrid(columns: columns, spacing: __designTimeInteger("#12338_32", fallback: 0)) {
            ForEach(__designTimeInteger("#12338_33", fallback: 0)..<days.count, id: \.self) { index in
                if let date = days[index] {
                    DayCell(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        events: taskManager.tasksForDate(date),
                        isToday: calendar.isDateInToday(date),
                        isCurrentMonth: calendar.isDate(date, equalTo: self.date, toGranularity: .month)
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: __designTimeFloat("#12338_34", fallback: 0.2))) {
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
        
        var days: [Date?] = Array(repeating: nil, count: firstWeekday - __designTimeInteger("#12338_35", fallback: 1))
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - __designTimeInteger("#12338_36", fallback: 1), to: start) {
                days.append(date)
            }
        }
        
        while days.count % __designTimeInteger("#12338_37", fallback: 7) != __designTimeInteger("#12338_38", fallback: 0) {
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
        VStack(spacing: __designTimeInteger("#12338_39", fallback: 4)) {
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
                            .fill(isSelected ? Color.blue.opacity(__designTimeFloat("#12338_40", fallback: 0.2)) : Color.clear)
                    )
            }
            
            if !events.isEmpty {
                HStack(spacing: __designTimeInteger("#12338_41", fallback: 4)) {
                    let incompleteTasks = events.filter { !$0.isCompleted }.prefix(__designTimeInteger("#12338_42", fallback: 2))
                    let completedTasks = events.filter { $0.isCompleted }.prefix(__designTimeInteger("#12338_43", fallback: 2))
                    
                    // Show incomplete tasks dots
                    ForEach(Array(incompleteTasks.enumerated()), id: \.1.id) { _, task in
                        Circle()
                            .fill(colorForList(task.listId))
                            .frame(width: __designTimeInteger("#12338_44", fallback: 4), height: __designTimeInteger("#12338_45", fallback: 4))
                    }
                    
                    // Show completed tasks dots in gray
                    ForEach(Array(completedTasks.enumerated()), id: \.1.id) { _, task in
                        Circle()
                            .fill(Color.gray)
                            .frame(width: __designTimeInteger("#12338_46", fallback: 4), height: __designTimeInteger("#12338_47", fallback: 4))
                    }
                    
                    // If there are more tasks than we can show dots for
                    if events.count > __designTimeInteger("#12338_48", fallback: 4) {
                        Text(__designTimeString("#12338_49", fallback: "•"))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .frame(height: __designTimeInteger("#12338_50", fallback: 45))
    }
    
    private func colorForList(_ listId: UUID) -> Color {
        // Get the list color from TaskManager
        // For now, return a default color
        .blue
    }
} 
