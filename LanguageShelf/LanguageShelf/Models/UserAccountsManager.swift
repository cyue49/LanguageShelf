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
    
    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
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
    
    func getUsers() {
        users.removeAll()
        
        let db = Firestore.firestore()
        let ref = db.collection("Users")
        ref.getDocuments { snapshot, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    
                    let email = data["email"] as? String ?? ""
                    let username = data["username"] as? String ?? ""
                    
                    let user = User(email: email, username: username)
                    self.users.append(user)
                }
            }
        }
    }
    
    func addUser(email: String, username: String) {
        let db = Firestore.firestore()
        let ref = db.collection("Users").document(email)
        ref.setData(["email": email, "username": username]) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
