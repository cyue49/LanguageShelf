import Foundation

struct WordDefinitions: Codable, Identifiable {
    let id: UUID = UUID()
    let word: String
    let phonetic: String
    let meanings: [Meaning]
}

struct Meaning: Codable, Identifiable {
    let id: UUID = UUID()
    let partOfSpeech: String
    let definitions: [Definition]
    let synonyms: [String]
    let antonyms: [String]
}

struct Definition: Codable, Identifiable {
    let id: UUID = UUID()
    let definition: String
    let synonyms: [String]
    let antonyms: [String]
}
