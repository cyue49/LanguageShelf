import Foundation

struct Book: Identifiable {
    var id: String // bookID
    var bookshelfID: String
    var userID: String
    var title: String
    var author: String 
    var description: String
    var picture: String = ""
    
    init(id: String=UUID().description, bookshelfID: String, userID: String, title: String, author: String="", description: String="", picture: String="") {
        self.id = id
        self.bookshelfID = bookshelfID
        self.userID = userID
        self.title = title
        self.author = author
        self.description = description
        self.picture = picture
    }
}
