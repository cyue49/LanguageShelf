import Foundation
import Firebase

@MainActor
class BookshelvesManager: ObservableObject {
    @Published var myBookshelves: [Bookshelf] = [] // list of all bookshelves for this user
    
    private let ref = Firestore.firestore().collection("Bookshelves")
    
    init() {
        Task {
            await fetchBookshelves()
        }
    }
    
    // get array of all user's bookshelves (called on app open and on login)
    func fetchBookshelves() async {
        guard let uid = Auth.auth().currentUser?.uid else { return } // if user not signed in, return

        self.myBookshelves = []
        let query = ref.whereField("userID", isEqualTo: uid)
        guard let snapshot = try? await query.getDocuments() else { return }
        
        for document in snapshot.documents {
            let data = document.data()
            let bookshelfID = data["bookshelfID"] as? String ?? ""
            let userID = data["userID"] as? String ?? ""
            let bookshelfName = data["bookshelfName"] as? String ?? ""
            let picture = data["picture"] as? String ?? ""
            let newBookshelf = Bookshelf(bookshelfID: bookshelfID, userID: userID, bookshelfName: bookshelfName, picture: picture)
            self.myBookshelves.append(newBookshelf)
        }
        sortByName()
    }
    
    // add new bookshelf to user's bookshelves
    func addNewBookshelf(name: String) async throws {
        // if bookshelf of this name already exists throw error
            for bookshelf in myBookshelves {
                if bookshelf.bookshelfName == name {
                    throw DataErrors.existingNameError
                }
            }
        
        // if user didn't enter a name for the new bookshelf throw error
        if (name.isEmpty){
            throw DataErrors.emptyNameError
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let newBookshelf = Bookshelf(userID: uid, bookshelfName: name)
        
        try await ref.document(newBookshelf.id).setData(["bookshelfID": newBookshelf.id, "userID": newBookshelf.userID, "bookshelfName": newBookshelf.bookshelfName])
        await fetchBookshelves()
    }
    
    // delete a bookshelf from bookshelves
    func removeBookshelf(bookshelfID: String) async throws {
        try await ref.document(bookshelfID).delete()
        await fetchBookshelves()
    }
    
    // update the name of a bookshelf
    func renameBookshelf(bookshelfID: String, newName: String) async throws {
        // if bookshelf of this name already exists throw error
            for bookshelf in myBookshelves {
                if bookshelf.bookshelfName == newName {
                    throw DataErrors.existingNameError
                }
            }
        
        // if user renames to an empty string throw error
        if (newName.isEmpty){
            throw DataErrors.emptyNameError
        }
        
        try await ref.document(bookshelfID).updateData(["bookshelfName": newName])
        await fetchBookshelves()
    }
    
    func sortByName() {
        if myBookshelves.count > 1 {
            self.myBookshelves.sort(by: {$0.bookshelfName < $1.bookshelfName})
        }
    }
    
    // update path to cover picture
    func updatePicture(bookshelfID: String, picturePath: String) async throws {
        try await ref.document(bookshelfID).updateData(["bookshelfName": picturePath])
        await fetchBookshelves()
    }
}
