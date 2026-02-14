import Foundation
import SwiftUI

class NotesViewModel: ObservableObject {
    
    // MARK: - Persistent Storage
    // AppStorage stores the JSON-encoded notes string in UserDefaults
    @AppStorage("notesData") private var notesData: String = ""
    
    // MARK: - Published Notes
    // @Published notifies SwiftUI views whenever the notes array changes
    @Published var notes: [Note] = []
    
    // MARK: - Initialization
    init() {
        loadNotes()
    }
    
    // MARK: - Add a New Note
    /// Creates a new Note with the given title and content, appends it to the array,
    /// and persists the updated list.
    func addNote(title: String, content: String) {
        let newNote = Note(title: title, content: content)
        notes.append(newNote)
        saveNotes()
    }
    
    // MARK: - Update an Existing Note
    /// Finds the note by its UUID and updates its title and content.
    func updateNote(id: UUID, title: String, content: String) {
        if let index = notes.firstIndex(where: { $0.id == id }) {
            notes[index].title = title
            notes[index].content = content
            saveNotes()
        }
    }
    
    // MARK: - Toggle Completion Status
    /// Toggles the `isCompleted` flag for the note with the given UUID.
    func toggleCompletion(for id: UUID) {
        if let index = notes.firstIndex(where: { $0.id == id }) {
            notes[index].isCompleted.toggle()
            saveNotes()
        }
    }
    
    // MARK: - Delete Notes
    /// Removes notes at the specified index set (used by List's .onDelete modifier).
    func deleteNotes(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        saveNotes()
    }
    
    // MARK: - Save Notes to AppStorage
    /// Encodes the notes array to JSON and stores it in AppStorage.
    private func saveNotes() {
        do {
            let data = try JSONEncoder().encode(notes)
            notesData = String(data: data, encoding: .utf8) ?? ""
        } catch {
            print("Error saving notes: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Load Notes from AppStorage
    /// Decodes the JSON string from AppStorage back into a notes array.
    /// If no data exists or decoding fails, starts with an empty array.
    private func loadNotes() {
        guard !notesData.isEmpty,
              let data = notesData.data(using: .utf8) else {
            notes = []
            return
        }
        
        do {
            notes = try JSONDecoder().decode([Note].self, from: data)
        } catch {
            print("Error loading notes: \(error.localizedDescription)")
            notes = []
        }
    }
}
