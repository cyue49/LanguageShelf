import Foundation

struct Vocabulary: Identifiable {
    var id: String // vocabularyID
    var bookID: String
    var userID: String
    var word: String
    var definition: String
    var note: String
    
    init(id: String=UUID().description, bookID: String, userID: String, word: String, definition: String, note: String="") {
        self.id = id
        self.bookID = bookID
        self.userID = userID
        self.word = word
        self.definition = definition
        self.note = note
    }}
