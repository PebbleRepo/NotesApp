import Foundation

struct Note: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var content: String
    var isCompleted: Bool = false
}
