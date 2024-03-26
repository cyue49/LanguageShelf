import Foundation
import Firebase

@MainActor
class SentencesManager: ObservableObject {
    @Published var mySentences: [String:[Sentence]] = [:] // dictionary of all sentences for the user (key: bookID, value: array of sentences for that book)
    
    private let ref = Firestore.firestore().collection("Sentences")
    
    init() {
        Task {
            await fetchSentences()
        }
    }
    
    func fetchSentences() async {}
    
    func addNewSentence(bookID: String, newSentence: String, linkedWords: [String]) async throws {}
    
    func removeSentence(sentenceID: String) async throws {}
    
    func updateSentence(bookID: String, sentenceID: String, newSentence: String, linkedWords: [String]) async throws {}
}
