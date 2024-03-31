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
    
    func addNewSentence(bookID: String, newSentence: String, linkedWords: [String]) async throws {
        // if sentence already exists in this book throw error
        if mySentences[bookID] != nil {
            for sentence in mySentences[bookID]! {
                if sentence.sentence == newSentence {
                    throw DataErrors.existingNameError
                }
            }
        }
        
        // if user entered empty string for sentence, throw error
        if (newSentence.isEmpty){
            throw DataErrors.emptyNameError
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let aNewSentence = Sentence(bookID: bookID, userID: uid, sentence: newSentence, linkedWords: linkedWords)
        
        try await ref.document(aNewSentence.id).setData(["sentenceID": aNewSentence.id, "bookID": aNewSentence.bookID, "userID": aNewSentence.userID, "sentence": aNewSentence.sentence, "linkedWords": aNewSentence.linkedWords])
        await fetchSentences()
    }
    
    func removeSentence(sentenceID: String) async throws {
        try await ref.document(sentenceID).delete()
        await fetchSentences()
    }
    
    func updateSentence(bookID: String, sentenceID: String, newSentence: String, linkedWords: [String]) async throws {
        // if sentence already exists in this book throw error
        if mySentences[bookID] != nil {
            for sentence in mySentences[bookID]! {
                if sentence.sentence == newSentence && sentence.id != sentenceID {
                    throw DataErrors.existingNameError
                }
            }
        }
        
        // if user entered empty string for sentence, throw error
        if (newSentence.isEmpty){
            throw DataErrors.emptyNameError
        }
        
        try await ref.document(sentenceID).updateData(["sentence": newSentence, "linkedWords": linkedWords])
        await fetchSentences()
    }
    
    func updateLinkedSentenceForVocabulary(vocabulary: String, oldSentences: [String], newSentences: [String]) async throws {
        // remove vocab from sentences
        for sentence in oldSentences {
            if !newSentences.contains(sentence){ // if this sentence no longer linked to the vocab, remove
                let query = ref.whereField("sentence", isEqualTo: sentence)
                guard let snapshot = try? await query.getDocuments() else { return }
                
                for document in snapshot.documents {
                    let data = document.data()
                    let sentenceID = data["sentenceID"] as? String ?? ""
                    var linkedWords = data["linkedWords"] as? [String] ?? []
                    if let index = linkedWords.firstIndex(of: vocabulary){
                        linkedWords.remove(at: index)
                    }
                    try await ref.document(sentenceID).updateData(["linkedWords": linkedWords])
                }
            }
        }
        
        // add vocab to sentences
        for sentence in newSentences {
            let query = ref.whereField("sentence", isEqualTo: sentence)
            guard let snapshot = try? await query.getDocuments() else { return }
            
            for document in snapshot.documents {
                let data = document.data()
                let sentenceID = data["sentenceID"] as? String ?? ""
                var linkedWords = data["linkedWords"] as? [String] ?? []
                if !linkedWords.contains(vocabulary){
                    linkedWords.append(vocabulary)
                }
                try await ref.document(sentenceID).updateData(["linkedWords": linkedWords])
            }
        }
        
        await fetchSentences()
    }
    
    func fetchSentenceFromID(id: String) async throws -> Sentence {
        if let data = try await ref.document(id).getDocument().data() {
            let sentenceID = data["sentenceID"] as? String ?? ""
            let userID = data["userID"] as? String ?? ""
            let bookID = data["bookID"] as? String ?? ""
            let sentence = data["sentence"] as? String ?? ""
            let linkedWords = data["linkedWords"] as? [String] ?? []
            let fetchedSentence = Sentence(id: sentenceID, bookID: bookID, userID: userID, sentence: sentence, linkedWords: linkedWords)
            return fetchedSentence
        }
        return Sentence(id: "", bookID: "", userID: "", sentence: "", linkedWords: [])
    }
    
    func fetchAllSentencesInBook(bookID: String) async throws -> [Sentence] {
        let query = ref.whereField("bookID", isEqualTo: bookID)
        guard let snapshot = try? await query.getDocuments() else { return []}
        
        var result: [Sentence] = []
        
        for document in snapshot.documents {
            let data = document.data()
            let sentenceID = data["sentenceID"] as? String ?? ""
            let userID = data["userID"] as? String ?? ""
            let bookID = data["bookID"] as? String ?? ""
            let sentence = data["sentence"] as? String ?? ""
            let linkedWords = data["linkedWords"] as? [String] ?? []
            let fetchedSentence = Sentence(id: sentenceID, bookID: bookID, userID: userID, sentence: sentence, linkedWords: linkedWords)
            result.append(fetchedSentence)
        }
        
        return result
    }
}
