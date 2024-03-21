import Foundation
import Firebase

@MainActor
class BookshelvesManager: ObservableObject {
    @Published var myBookshelves: [String]? // list of all bookshelves for this user
    
    init() {
        Task {
            await fetchBookshelves()
        }
    }
    
    func fetchBookshelves() async {
        guard let uid = Auth.auth().currentUser?.uid else { return } // each document of the bookshelves collection uses the user id as id, so fetch using user id
        guard let arr = try? await Firestore.firestore().collection("Bookshelves").document(uid).getDocument() else { return }
        let bookshelves = arr["bookshelves"] as? [String] ?? []
        self.myBookshelves = bookshelves
    }
}
