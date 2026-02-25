import SwiftUI

struct NotesHomeView: View {
    @ObservedObject var viewModel: NotesViewModel
    
    var body: some View {
        ZStack {
            // MARK: - Gradient Background (Customization 1)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.12, green: 0.13, blue: 0.20),
                    Color(red: 0.18, green: 0.20, blue: 0.32)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if viewModel.notes.isEmpty {
                // Empty state
                VStack(spacing: 16) {
                    Image(systemName: "note.text.badge.plus")
                        .font(.system(size: 60))
                        .foregroundColor(.white.opacity(0.3))
                    Text("No Notes Yet")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.5))
                    Text("Tap + to create your first note")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.35))
                }
            } else {
                List {
                    ForEach(viewModel.notes) { note in
                        NavigationLink(destination: NoteDetailView(viewModel: viewModel, note: note)) {
                            noteRow(note)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .onDelete { offsets in
                        viewModel.deleteNotes(at: offsets)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
        }
        .navigationTitle("My Notes")
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddEditNoteView(viewModel: viewModel)) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.cyan)
                }
            }
        }
    }
    
    // MARK: - Note Row (Customization 2 — Card Styling with Shadows & Borders)
    @ViewBuilder
    private func noteRow(_ note: Note) -> some View {
        HStack(spacing: 14) {
            // Completion indicator
            Image(systemName: note.isCompleted ? "checkmark.circle.fill" : "circle")
                .font(.title3)
                .foregroundColor(note.isCompleted ? .green : .white.opacity(0.4))
            
            VStack(alignment: .leading, spacing: 4) {
                // Title with strikethrough if completed
                Text(note.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .kerning(0.3)
                    .foregroundColor(note.isCompleted ? .white.opacity(0.45) : .white)
                    .strikethrough(note.isCompleted, color: .green.opacity(0.7))
                
                // Content preview
                Text(note.content)
                    .font(.subheadline)
                    .foregroundColor(note.isCompleted ? .white.opacity(0.3) : .white.opacity(0.6))
                    .lineLimit(2)
                    .lineSpacing(2)
            }
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(note.isCompleted
                      ? Color.white.opacity(0.04)
                      : Color.white.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(note.isCompleted
                        ? Color.green.opacity(0.2)
                        : Color.white.opacity(0.1), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.25), radius: 6, x: 0, y: 3)
        .padding(.vertical, 4)
    }
}
