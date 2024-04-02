import Foundation

struct Bookshelf: Identifiable {
    var id: String // bookshelfID
    var userID: String
    var bookshelfName: String
    var picture: String
    
    init(bookshelfID: String=UUID().description, userID: String, bookshelfName: String, picture: String="") {
        self.id = bookshelfID
        self.userID = userID
        self.bookshelfName = bookshelfName
        self.picture = picture
    }
}
