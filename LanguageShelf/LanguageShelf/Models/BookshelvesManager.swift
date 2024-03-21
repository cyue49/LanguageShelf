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
    
    // add new bookshelf to user's bookshelves
    func addNewBookshelf(name: String) async throws -> Bool {
        if myBookshelves != nil && myBookshelves!.contains(name){
            return true // if bookshelf of this name already exists, show alert
        }
        myBookshelves?.append(name)
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        try await Firestore.firestore().collection("Bookshelves").document(uid).setData(["bookshelves": myBookshelves!])
        await fetchBookshelves()
        return false
    }
    
    // delete a bookshelf from bookshelves
    func removeBookshelf(name: String) async throws {
        myBookshelves!.remove(at: myBookshelves!.firstIndex(of: name)!)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await Firestore.firestore().collection("Bookshelves").document(uid).setData(["bookshelves": myBookshelves!])
        await fetchBookshelves()
    }
    
    // update the name of a bookshelf
    
}
