import Foundation
import Firebase

@MainActor
class BooksManager: ObservableObject {
    @Published var myBooks: [Book] = [] // list of all books on a bookshelf
    
    private let ref = Firestore.firestore().collection("Books")
    
    init() {
        Task {
            await fetchBooks()
        }
    }
    
    func fetchBooks() async {
        // TODO: fetch all books on bookshelf
    }
}

