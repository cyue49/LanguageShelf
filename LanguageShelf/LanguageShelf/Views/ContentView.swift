import SwiftUI
import Firebase

struct ContentView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var body: some View {
        TabView {
            MyBookshelvesView()
                .tabItem {
                    Label("Bookshelves",systemImage: "books.vertical.fill")
                }
                .toolbarBackground(userManager.currentTheme.toolbarColor, for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
//                .onAppear() {
//                    if userManager.userSession != nil && userManager.currentUser != nil {
//                        userManager.setTheme(theme: Int(userManager.currentUser!.theme)!)
//                        print("here")
//                    }
//                }
            GameScreenView()
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
    }
}
