import Foundation

struct Sentence: Identifiable {
    var id: String // sentenceID
    var bookID: String
    var userID: String
    var sentence: String
    var linkedWords: [String]
    
    init(id: String=UUID().description, bookID: String, userID: String, sentence: String, linkedWords: [String]) {
        self.id = id
        self.bookID = bookID
        self.userID = userID
        self.sentence = sentence
        self.linkedWords = linkedWords
    }
}
