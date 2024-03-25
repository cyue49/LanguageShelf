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
    
    func fetchVocabularies() async {}
    
    func addNewVocabulary() async throws {}
    
    func removeVocabulary() async throws {}
    
    func updateVocabulary() async throws {}
}
