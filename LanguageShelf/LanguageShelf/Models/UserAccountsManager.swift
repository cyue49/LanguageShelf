import Foundation
import Firebase

@MainActor
class UserAccountsManager: ObservableObject {
    // For user authentication
    @Published var userSession: FirebaseAuth.User? // whether user is signed in or not
    @Published var currentUser: User? // current user
    @Published var verifiedUser: Bool
    
    // For user preference theme
    @Published var currentTheme: ThemeProtocol = DefaultTheme()
    var themeSets: [ThemeProtocol] = [DefaultTheme(), LightTheme(), DarkTheme(), GreenTheme()]
    
    // database reference
    private let ref = Firestore.firestore().collection("Users")
    
    private let allSpaceRegex = NSPredicate(format: "SELF MATCHES %@ ", "^ *$")
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.verifiedUser = (Auth.auth().currentUser != nil) ? Auth.auth().currentUser!.isEmailVerified : false
        
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
        sendUserEmailVerification(user: self.userSession!)
        let user = User(id: result.user.uid, email: email, username: username, theme: "0")
        try await ref.document(user.id).setData(["id": user.id, "email": email, "username": username, "theme": 0, "profilePicture": ""])
        await fetchUser()
    }
    
    func sendUserEmailVerification(user: FirebaseAuth.User) {
        if !user.isEmailVerified {
            self.userSession!.sendEmailVerification()
        }
    }
    
    // set current user
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await ref.document(uid).getDocument() else { return }
        let email = snapshot["email"] as? String ?? ""
        let username = snapshot["username"] as? String ?? ""
        let theme = snapshot["theme"] as? String ?? "0"
        let profilePicture = snapshot["profilePicture"] as? String ?? ""
        self.currentUser = User(id: uid, email: email, username: username, theme: theme, profilePicture: profilePicture)
        self.currentTheme = themeSets[Int(theme)!] // set theme to user preference
    }
    
    func reloadUser() async throws {
        try await Auth.auth().currentUser!.reload()
        self.userSession = Auth.auth().currentUser
        self.verifiedUser = (userSession != nil) ? userSession!.isEmailVerified : false
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
        if (attribute == "username" && (value.isEmpty || allSpaceRegex.evaluate(with: value))){ // if user is editing their username but doesn't enter a new name before submit
            throw DataErrors.emptyNameError
        }
        
        do {
            try await ref.document(userSession!.uid).updateData([attribute: value])
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
