import Foundation

struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String?
    var dueDate: Date
    var isCompleted: Bool
    var sectionId: UUID
    var listId: UUID
    
    init(id: UUID = UUID(), 
         title: String, 
         description: String? = nil, 
         dueDate: Date, 
         isCompleted: Bool = false,
         sectionId: UUID,
         listId: UUID) {
        self.id = id
        self.title = title
        self.description = description
        self.dueDate = dueDate
        self.isCompleted = isCompleted
        self.sectionId = sectionId
        self.listId = listId
    }
} 