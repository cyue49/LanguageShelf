import Foundation
import Firebase

@MainActor
class UserAccountsManager: ObservableObject {
    @Published var users: [User] = []
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
         self.userSession = Auth.auth().currentUser
        Task {
            await fetchUser()
        }
    }
    
    func signIn(email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("ERROR SIGNING IN USER: \(error.localizedDescription)")
        }
    }
    
    func register(email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(email: email, username: username)
            try await Firestore.firestore().collection("Users").document(user.email).setData(["email": email, "username": username])
            await fetchUser()
        } catch {
            print("ERROR CREATING USER: \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("Users").document(uid).getDocument() else { return }
        let email = snapshot["email"] as? String ?? ""
        let username = snapshot["username"] as? String ?? ""
        self.currentUser = User(email: email, username: username)
    }
    
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
