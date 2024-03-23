import Foundation

struct Bookshelf: Identifiable {
    var id: String // bookshelfID
    var userID: String
    var bookshelfName: String
    
    init(bookshelfID: String=UUID().description, userID: String, bookshelfName: String) {
        self.id = bookshelfID
        self.userID = userID
        self.bookshelfName = bookshelfName
    }
}
