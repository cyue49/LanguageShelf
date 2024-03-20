import SwiftUI
import Firebase

@main
struct LanguageShelfApp: App {
    @StateObject var userManager = UserAccountsManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userManager)
        }
    }
    
}
