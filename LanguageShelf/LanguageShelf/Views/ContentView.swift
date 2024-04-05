import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    var body: some View {
        TabView {
            MyBookshelvesView()
                .tabItem {
                    Label("Bookshelves",systemImage: "books.vertical.fill")
                }
                .toolbarBackground(userManager.currentTheme.toolbarColor, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            GameStartScreenView()
                .tabItem {
                    Label("Game",systemImage: "gamecontroller.fill")
                }
                .toolbarBackground(userManager.currentTheme.toolbarColor, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            UserProfileView()
                .tabItem {
                    Label("Profile",systemImage: "person.fill")
                }
                .toolbarBackground(userManager.currentTheme.toolbarColor, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
            .environmentObject(SentencesManager())
    }
}
