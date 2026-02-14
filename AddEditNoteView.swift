import SwiftUI

struct AddEditNoteView: View {
    @ObservedObject var viewModel: NotesViewModel
    @Environment(\.dismiss) var dismiss
    
    /// If editing an existing note, this will be set; otherwise nil means "add" mode
    var existingNote: Note? = nil
    
    @State private var title: String = ""
    @State private var content: String = ""
    
    /// True when editing, false when adding
    private var isEditing: Bool {
        existingNote != nil
    }
    
    var body: some View {
        ZStack {
            // MARK: - Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.12, green: 0.13, blue: 0.20),
                    Color(red: 0.18, green: 0.20, blue: 0.32)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // MARK: - Title Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Title")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.6))
                    
                    TextField("Enter note title...", text: $title)
                        .font(.headline)
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.08))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                        .foregroundColor(.white)
                }
                
                // MARK: - Content Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Content")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.6))
                    
                    TextEditor(text: $content)
                        .font(.body)
                        .foregroundColor(.white)
                        .scrollContentBackground(.hidden)
                        .padding(14)
                        .frame(minHeight: 200)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.08))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                }
                
                Spacer()
            }
            .padding(24)
        }
        .navigationTitle(isEditing ? "Edit Note" : "New Note")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: saveNote) {
                    Text("Save")
                        .fontWeight(.bold)
                        .foregroundColor(title.isEmpty ? .gray : .cyan)
                }
                .disabled(title.isEmpty)
            }
        }
        .onAppear {
            // Pre-populate fields when editing an existing note
            if let note = existingNote {
                title = note.title
                content = note.content
            }
        }
    }
    
    // MARK: - Save Action
    private func saveNote() {
        if let note = existingNote {
            viewModel.updateNote(id: note.id, title: title, content: content)
        } else {
            viewModel.addNote(title: title, content: content)
        }
        dismiss()
    }
}
