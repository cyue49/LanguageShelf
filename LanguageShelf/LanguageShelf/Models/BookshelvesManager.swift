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
    
    // get array of all user's bookshelves (called on app open and on login)
    func fetchBookshelves() async {
        guard let uid = Auth.auth().currentUser?.uid else { return } // each document of the bookshelves collection uses the user id as id, so fetch using user id
        guard let arr = try? await Firestore.firestore().collection("Bookshelves").document(uid).getDocument() else { return }
        let bookshelves = arr["bookshelves"] as? [String] ?? []
        self.myBookshelves = bookshelves
    }
    
    // create new bookshelf document with empty array for new user when sign up
    func createNewBookshelves() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("Bookshelves").document(uid).setData(["bookshelves": []]) 
        await fetchBookshelves()
    }
    
    func addNewBookshelf(name: String) async throws {
        myBookshelves?.append(name)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("Bookshelves").document(uid).setData(["bookshelves": myBookshelves!])
        await fetchBookshelves()
    }
}
