import Foundation

struct ListSection: Identifiable, Codable {
    let id: UUID
    var name: String
    var isCollapsed: Bool
    
    init(id: UUID = UUID(), name: String, isCollapsed: Bool = false) {
        self.id = id
        self.name = name
        self.isCollapsed = isCollapsed
    }
} 