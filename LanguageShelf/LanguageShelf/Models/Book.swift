import Foundation

struct Book: Identifiable {
    var id: String // bookID
    var bookshelfID: String
    var title: String
    var author: String 
    
    init(id: String=UUID().description, bookshelfID: String, title: String, author: String="") {
        self.id = id
        self.bookshelfID = bookshelfID
        self.title = title
        self.author = author
    }
}
