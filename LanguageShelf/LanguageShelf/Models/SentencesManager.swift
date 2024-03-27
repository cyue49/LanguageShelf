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
    
    func fetchSentences() async {
        guard let uid = Auth.auth().currentUser?.uid else { return } // if user not signed in, return
        
        self.mySentences = [:]
        
        let query = ref.whereField("userID", isEqualTo: uid)
        guard let snapshot = try? await query.getDocuments() else { return }
        
        for document in snapshot.documents {
            let data = document.data()
            let sentenceID = data["sentenceID"] as? String ?? ""
            let userID = data["userID"] as? String ?? ""
            let bookID = data["bookID"] as? String ?? ""
            let sentence = data["sentence"] as? String ?? ""
            let linkedWords = data["linkedWords"] as? [String] ?? []
            let newSentence = Sentence(id: sentenceID, bookID: bookID, userID: userID, sentence: sentence, linkedWords: linkedWords)
            mySentences[bookID] == nil ? mySentences[bookID] = [newSentence] : mySentences[bookID]!.append(newSentence)
        }
    }
    
    func addNewSentence(bookID: String, newSentence: String, linkedWords: [String]) async throws {}
    
    func removeSentence(sentenceID: String) async throws {}
    
    func updateSentence(bookID: String, sentenceID: String, newSentence: String, linkedWords: [String]) async throws {}
}
