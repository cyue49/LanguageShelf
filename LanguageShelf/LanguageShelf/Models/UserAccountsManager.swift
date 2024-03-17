import Foundation
import Firebase

class UserAccountsManager: ObservableObject {
    @Published var users: [User] = []
    
    init() {
        getUsers()
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
