import Foundation
import Firebase

@MainActor
class VocabulariesManager: ObservableObject {
    @Published var myVocabularies: [String:[Vocabulary]] = [:] // dictionary of all vocabularies for the user (key: bookID, value: array of vocabularies for that book)
    
    private let ref = Firestore.firestore().collection("Vocabularies")
    
    init() {
        Task {
            await fetchVocabularies()
        }
    }
    
    func fetchVocabularies() async {
        guard let uid = Auth.auth().currentUser?.uid else { return } // if user not signed in, return
        
        self.myVocabularies = [:]
        
        let query = ref.whereField("userID", isEqualTo: uid)
        guard let snapshot = try? await query.getDocuments() else { return }
        
        for document in snapshot.documents {
            let data = document.data()
            let vocabID = data["vocabID"] as? String ?? ""
            let userID = data["userID"] as? String ?? ""
            let bookID = data["bookID"] as? String ?? ""
            let word = data["word"] as? String ?? ""
            let definition = data["definition"] as? String ?? ""
            let note = data["note"] as? String ?? ""
            let newVocab = Vocabulary(id: vocabID, bookID: bookID, userID: userID, word: word, definition: definition, note: note)
            myVocabularies[bookID] == nil ? myVocabularies[bookID] = [newVocab] : myVocabularies[bookID]!.append(newVocab)
        }
    }
    
    func addNewVocabulary(bookID: String, newWord: String, newDefinition: String, newNote: String = "") async throws {
        // if vocabulary already exists in this book throw error
        if myVocabularies[bookID] != nil {
            for vocab in myVocabularies[bookID]! {
                if vocab.word == newWord {
                    throw DataErrors.existingNameError
                }
            }
        }
        
        // if user entered empty string for vocab or definition, throw error
        if (newWord.isEmpty || newDefinition.isEmpty){
            throw DataErrors.emptyNameError
        }
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let newVocab = Vocabulary(bookID: bookID, userID: uid, word: newWord, definition: newDefinition, note: newNote)
        
        try await ref.document(newVocab.id).setData(["vocabID": newVocab.id, "bookID": newVocab.bookID, "userID": newVocab.userID, "word": newVocab.word, "definition": newVocab.definition, "note": newVocab.note])
        await fetchVocabularies()
    }
    
    func removeVocabulary() async throws {}
    
    func updateVocabulary() async throws {}
}
