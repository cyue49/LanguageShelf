import Foundation

struct Book: Identifiable {
    var id: String // bookID
    var bookshelfID: String
    var userID: String
    var title: String
    var author: String 
    
    init(id: String=UUID().description, bookshelfID: String, userID: String, title: String, author: String="") {
        self.id = id
        self.bookshelfID = bookshelfID
        self.userID = userID
        self.title = title
        self.author = author
    }
}
