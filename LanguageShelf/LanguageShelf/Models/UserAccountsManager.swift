import Foundation
import Firebase

@MainActor
class UserAccountsManager: ObservableObject {
    @Published var userSession: FirebaseAuth.User? // whether user is signed in or not
    @Published var currentUser: User? // current user
    
    init() {
         self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    // set user session and current user and sign user in
    func signIn(email: String, password: String) async throws -> Bool {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("ERROR SIGNING IN USER: \(error.localizedDescription)")
            return true // show failed sign in alert
        }
        return false // don't show failed sign in alert
    }
    
    // create new user, add user info in firebase firestore, set user session, set current user
    func register(email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, email: email, username: username)
            try await Firestore.firestore().collection("Users").document(user.id).setData(["id": user.id, "email": email, "username": username])
            await fetchUser()
        } catch {
            print("ERROR CREATING USER: \(error.localizedDescription)")
        }
    }
    
    // set current user
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("Users").document(uid).getDocument() else { return }
        let email = snapshot["email"] as? String ?? ""
        let username = snapshot["username"] as? String ?? ""
        self.currentUser = User(id: uid, email: email, username: username)
    }
    
    // unset user session and current userß
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("ERROR SIGNING OUT USER: \(error.localizedDescription)")
        }
    }
}


protocol FormAuthProtocol {
    var validForm: Bool {
        get
    }
}
