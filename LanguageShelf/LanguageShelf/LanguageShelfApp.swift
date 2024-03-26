import SwiftUI
import Firebase

@main
struct LanguageShelfApp: App {
    @StateObject var userManager = UserAccountsManager()
    @StateObject var bookshelvesManager = BookshelvesManager()
    @StateObject var booksManager = BooksManager()
    @StateObject var vocabsManager = VocabulariesManager()
    @StateObject var sentencesManager = SentencesManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userManager)
                .environmentObject(bookshelvesManager)
                .environmentObject(booksManager)
                .environmentObject(vocabsManager)
                .environmentObject(sentencesManager)
        }
    }
    
}
