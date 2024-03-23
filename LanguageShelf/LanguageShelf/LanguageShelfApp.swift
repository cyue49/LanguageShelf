import SwiftUI
import Firebase

@main
struct LanguageShelfApp: App {
    @StateObject var userManager = UserAccountsManager()
    @StateObject var bookshelvesManager = BookshelvesManager()
    @StateObject var booksManager = BooksManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userManager)
                .environmentObject(bookshelvesManager)
                .environmentObject(booksManager)
        }
    }
    
}
