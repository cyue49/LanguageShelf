import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor(named: "ToolBarColor")
    }
    var body: some View {
        TabView {
            MyBookshelvesView()
                .tabItem {
                    Label("Bookshelves",systemImage: "books.vertical.fill")
                }
            GameScreenView()
                .tabItem {
                    Label("Game",systemImage: "gamecontroller.fill")
                }
            UserProfileView()
                .tabItem {
                    Label("Profile",systemImage: "person.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserAccountsManager())
    }
}
