import func SwiftUI.__designTimeFloat
import func SwiftUI.__designTimeString
import func SwiftUI.__designTimeInteger
import func SwiftUI.__designTimeBoolean

#sourceLocation(file: "/Users/daneohr/Downloads/Xcode Projects/Reminder Roast/Reminder Roast/Reminder Roast/ReminderList.swift", line: 1)
import Foundation
import SwiftUI

struct ReminderList: Identifiable, Codable {
    let id: UUID
    var name: String
    var icon: String
    var color: String
    var sections: [ListSection]
    var isPinned: Bool
    
    init(id: UUID = UUID(), name: String, icon: String = "list.bullet", color: String = "blue", sections: [ListSection] = [ListSection(name: "Default")], isPinned: Bool = false) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color.lowercased()
        self.sections = sections
        self.isPinned = isPinned
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case icon
        case color
        case sections
        case isPinned
    }
}
