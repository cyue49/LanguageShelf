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
            let user = User(id: result.user.uid, email: email, username: username, theme: "0")
            try await Firestore.firestore().collection("Users").document(user.id).setData(["id": user.id, "email": email, "username": username, "theme": 0])
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
        let theme = snapshot["theme"] as? String ?? "0"
        self.currentUser = User(id: uid, email: email, username: username, theme: theme)
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
    
    // update attribute with new value for current user
    func updateUser(attribute: String, value: String) async throws {
        do {
            try await Firestore.firestore().collection("Users").document(userSession!.uid).updateData([attribute: value])
        } catch {
            print("ERROR UPDATING DATA: \(error.localizedDescription)")
        }
    }
}


protocol FormAuthProtocol {
    var validForm: Bool {
        get
    }
}
