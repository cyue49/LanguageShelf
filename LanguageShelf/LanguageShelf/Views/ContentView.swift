import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        TabView {
            MyBookshelvesView()
                .tabItem {
                    Label("Bookshelves",systemImage: "books.vertical.fill")
                }
                .toolbarBackground(themeManager.currentTheme.toolbarColor, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            GameScreenView()
                .tabItem {
                    Label("Game",systemImage: "gamecontroller.fill")
                }
                .toolbarBackground(themeManager.currentTheme.toolbarColor, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
            UserProfileView()
                .tabItem {
                    Label("Profile",systemImage: "person.fill")
                }
                .toolbarBackground(themeManager.currentTheme.toolbarColor, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserAccountsManager())
            .environmentObject(ThemeManager())
    }
}
