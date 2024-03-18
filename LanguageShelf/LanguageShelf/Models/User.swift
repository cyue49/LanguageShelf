import Foundation

struct User: Identifiable {
    var id: String
    var email: String
    var username: String
    
    init(email: String, username: String) {
        self.id = email
        self.email = email
        self.username = username
    }
}
