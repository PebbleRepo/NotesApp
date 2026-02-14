import SwiftUI

@main
struct IndAss_2App: App {
    @StateObject private var viewModel = NotesViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(viewModel: viewModel)
            }
        }
    }
}
