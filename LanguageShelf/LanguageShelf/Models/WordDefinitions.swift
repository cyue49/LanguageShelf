import Foundation

struct WordDefinitions: Codable, Identifiable {
    let id: UUID = UUID()
    let word: String
    let phonetic: String
    let meanings: [Meaning]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.word = try container.decode(String.self, forKey: .word)
        self.phonetic = try container.decode(String.self, forKey: .phonetic)
        self.meanings = try container.decode([Meaning].self, forKey: .meanings)
    }
}

struct Meaning: Codable, Identifiable {
    let id: UUID = UUID()
    let partOfSpeech: String
    let definitions: [Definition]
    let synonyms: [String]
    let antonyms: [String]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.partOfSpeech = try container.decode(String.self, forKey: .partOfSpeech)
        self.definitions = try container.decode([Definition].self, forKey: .definitions)
        self.synonyms = try container.decode([String].self, forKey: .synonyms)
        self.antonyms = try container.decode([String].self, forKey: .antonyms)
    }
}

struct Definition: Codable, Identifiable {
    let id: UUID = UUID()
    let definition: String
    let synonyms: [String]
    let antonyms: [String]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.definition = try container.decode(String.self, forKey: .definition)
        self.synonyms = try container.decode([String].self, forKey: .synonyms)
        self.antonyms = try container.decode([String].self, forKey: .antonyms)
    }
}
