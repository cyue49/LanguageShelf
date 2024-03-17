import SwiftUI
import Firebase

@main
struct LanguageShelfApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
}
