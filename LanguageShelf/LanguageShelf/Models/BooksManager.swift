import Foundation
import Firebase

@MainActor
class BooksManager: ObservableObject {
    @Published var myBooks: [String:[Book]] = [:] // dictionary of all books (key: bookshelfID, value: array of books in that bookshelf)
    
    private let ref = Firestore.firestore().collection("Books")
    
    init() {
        Task {
            await fetchBooks()
        }
    }
    
    // get all books of the user into a dictionary with the bookshelfID as key and an array of the books on that shelf as the value
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
    
    // add new book to a bookshelf
    func addNewBook(bookshelfID: String, bookName: String) async throws {
        // if book of this name already exists in this bookshelf throw error
        if myBooks[bookshelfID] != nil {
            for book in myBooks[bookshelfID]! {
                if book.title == bookName {
                    throw DataErrors.existingNameError
                }
            }
        }
        
        // if user didn't enter a name for the new book throw error
        if (bookName.isEmpty){
            throw DataErrors.emptyNameError
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let newBook = Book(bookshelfID: bookshelfID, userID: uid, title: bookName)
        
        try await ref.document(newBook.id).setData(["bookID": newBook.id, "bookshelfID": newBook.bookshelfID, "userID": newBook.userID, "title": newBook.title, "author": newBook.author])
        await fetchBooks()
    }
    
    // delete a book from a bookshelf
    func removeBook(bookID: String) async throws {
        try await ref.document(bookID).delete()
        await fetchBooks()
    }
}
