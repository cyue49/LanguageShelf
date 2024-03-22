import Foundation
import Firebase

@MainActor
class UserAccountsManager: ObservableObject {
    // For user authentication
    @Published var userSession: FirebaseAuth.User? // whether user is signed in or not
    @Published var currentUser: User? // current user
    
    // For user preference theme
    @Published var currentTheme: ThemeProtocol = DefaultTheme()
    var themeSets: [ThemeProtocol] = [DefaultTheme(), LightTheme(), DarkTheme(), GreenTheme()]
    
    init() {
         self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    // set user session and current user and sign user in
    func signIn(email: String, password: String) async throws {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
    }
    
    // create new user, add user info in firebase firestore, set user session, set current user
    func register(email: String, password: String, username: String) async throws {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, email: email, username: username, theme: "0")
            try await Firestore.firestore().collection("Users").document(user.id).setData(["id": user.id, "email": email, "username": username, "theme": 0])
            await fetchUser()
    }
    
    // set current user
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("Users").document(uid).getDocument() else { return }
        let email = snapshot["email"] as? String ?? ""
        let username = snapshot["username"] as? String ?? ""
        let theme = snapshot["theme"] as? String ?? "0"
        self.currentUser = User(id: uid, email: email, username: username, theme: theme)
        self.currentTheme = themeSets[Int(theme)!] // set theme to user preference
    }
    
    // unset user session and current userß
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            self.currentTheme = themeSets[0] // reset theme to default on signout
        } catch {
            print("ERROR SIGNING OUT USER: \(error.localizedDescription)")
        }
    }
    
    // update attribute with new value for current user
    func updateUser(attribute: String, value: String) async throws {
        if (attribute == "username" && value.isEmpty){ // if user is editing their username but doesn't enter a new name before submit
            throw DataErrors.emptyNameError
        }
        
        do {
            try await Firestore.firestore().collection("Users").document(userSession!.uid).updateData([attribute: value])
            await fetchUser()
        } catch {
            print("ERROR UPDATING DATA: \(error.localizedDescription)")
        }
    }
    
    // Set app theme
    func setTheme(theme: Int) {
        currentTheme = themeSets[theme]
    }
}


protocol FormAuthProtocol {
    var validForm: Bool {
        get
    }
}
