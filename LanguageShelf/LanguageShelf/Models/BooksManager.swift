import Foundation
import Firebase

@MainActor
class BooksManager: ObservableObject {
    @Published var myBooks: [String:[Book]] = [:] // list of all books on a bookshelf
    
    private let ref = Firestore.firestore().collection("Books")
    
    init() {
        Task {
            await fetchBooks()
        }
    }
    
    func fetchBooks() async {
        guard let uid = Auth.auth().currentUser?.uid else { return } // if user not signed in, return
        
        self.myBooks = [:]
        
        let query = ref.whereField("userID", isEqualTo: uid)
        guard let snapshot = try? await query.getDocuments() else { return }
        
        for document in snapshot.documents {
            let data = document.data()
            let bookshelfID = data["bookshelfID"] as? String ?? ""
            let userID = data["userID"] as? String ?? ""
            let bookID = data["bookID"] as? String ?? ""
            let title = data["title"] as? String ?? ""
            let author = data["author"] as? String ?? ""
            let newBook = Book(id: bookID, bookshelfID: bookshelfID, userID: userID, title: title, author: author)
            myBooks[bookshelfID] == nil ? myBooks[bookshelfID] = [newBook] : myBooks[bookshelfID]!.append(newBook)
        }
    }
}

