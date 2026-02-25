import SwiftUI

struct NoteDetailView: View {
    @ObservedObject var viewModel: NotesViewModel
    let note: Note
    
    /// Returns the latest version of the note from the view model
    private var currentNote: Note {
        viewModel.notes.first(where: { $0.id == note.id }) ?? note
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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // MARK: - Title
                    Text(currentNote.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .kerning(0.5)
                        .foregroundColor(currentNote.isCompleted ? .white.opacity(0.5) : .white)
                        .strikethrough(currentNote.isCompleted, color: .green.opacity(0.7))
                    
                    // MARK: - Status Badge
                    HStack(spacing: 6) {
                        Image(systemName: currentNote.isCompleted ? "checkmark.seal.fill" : "clock")
                            .foregroundColor(currentNote.isCompleted ? .green : .orange)
                        Text(currentNote.isCompleted ? "Completed" : "In Progress")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(currentNote.isCompleted ? .green : .orange)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(currentNote.isCompleted
                                  ? Color.green.opacity(0.15)
                                  : Color.orange.opacity(0.15))
                    )
                    
                    // MARK: - Content
                    Text(currentNote.content)
                        .font(.body)
                        .foregroundColor(currentNote.isCompleted ? .white.opacity(0.4) : .white.opacity(0.85))
                        .strikethrough(currentNote.isCompleted, color: .green.opacity(0.5))
                        .lineSpacing(6)
                    
                    Spacer(minLength: 30)
                    
                    // MARK: - Toggle Completion Button (Customization 2 — Styled Button)
                    Button(action: {
                        viewModel.toggleCompletion(for: note.id)
                    }) {
                        HStack {
                            Image(systemName: currentNote.isCompleted ? "arrow.uturn.backward.circle" : "checkmark.circle")
                            Text(currentNote.isCompleted ? "Mark as Incomplete" : "Mark as Completed")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(currentNote.isCompleted
                                      ? Color.orange.opacity(0.8)
                                      : Color.green.opacity(0.8))
                        )
                        .foregroundColor(.white)
                        .shadow(color: (currentNote.isCompleted ? Color.orange : Color.green).opacity(0.4),
                                radius: 8, x: 0, y: 4)
                    }
                }
                .padding(24)
            }
        }
        .navigationTitle("Note Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddEditNoteView(viewModel: viewModel, existingNote: currentNote)) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title3)
                        .foregroundColor(.cyan)
                }
            }
        }
    }
}
