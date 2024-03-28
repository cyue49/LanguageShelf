import SwiftUI

struct LinkSentenceOrVocabView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    var book: Book
    var sentence: Sentence = Sentence(id: "", bookID: "", userID: "", sentence: "", linkedWords: [])
    var vocabulary: Vocabulary = Vocabulary(id: "", bookID: "", userID: "", word: "", definition: "")
    
    @State var updatedVocab: Vocabulary = Vocabulary(id: "", bookID: "", userID: "", word: "", definition: "")
    @State var updatedSentence: Sentence = Sentence(id: "", bookID: "", userID: "", sentence: "", linkedWords: [])
    @State var alreadyLinkedElements: [String] = []
    
    var linkingSentences = true // true if vocab entry wants to link sentences, false if sentence entry wants to link vocab
    
    @State var showSelectSentencesSheet = false
    @State var showSelectVocabsSheet = false
    
    @State var linkedVocabs: [Vocabulary] = []
    @State var linkedSentences: [Sentence] = []
    
    var body: some View {
        VStack {
            HStack {
                if linkingSentences {
                    Text("Related sentences:")
                        .font(.subheadline)
                        .foregroundStyle(userManager.currentTheme.fontColor)
                } else {
                    Text("Related vocabularies:")
                        .font(.subheadline)
                        .foregroundStyle(userManager.currentTheme.fontColor)
                }
                Spacer()
                Button(action: {
                    if linkingSentences { // vocab links sentence
                        showSelectSentencesSheet.toggle()
                    } else { // sentence links vocab
                        showSelectVocabsSheet.toggle()
                    }
                }, label: {
                    Image(systemName: "paperclip.circle.fill")
                        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                        .bold()
                        .font(.system(size: 26))
                })
            }
            
            ScrollView {
                if linkingSentences {
                    VStack {
                        if linkedSentences.isEmpty {
                            Text("No linked sentences yet.")
                                .foregroundStyle(userManager.currentTheme.fontColor)
                                .padding()
                        }
                        ForEach(linkedSentences) { sent in
                            NavigationLink(destination: SentenceDetailsView(book: book, sentence: sent)) {
                                Text(sent.sentence)
                                    .foregroundStyle(userManager.currentTheme.fontColor)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .background(
                                        Rectangle()
                                            .foregroundColor(userManager.currentTheme.buttonColor)
                                            .cornerRadius(20)
                                    )
                            }
                        }
                    }
                    .padding()
                } else {
                    VStack {
                        if linkedVocabs.isEmpty {
                            Text("No linked vocabularies yet.")
                                .foregroundStyle(userManager.currentTheme.fontColor)
                                .padding()
                        }
                        ForEach(linkedVocabs) { vocab in
                            NavigationLink(destination: VocabularyDetailsView(book: book, vocabulary: vocab)) {
                                Text(vocab.word)
                                    .foregroundStyle(userManager.currentTheme.fontColor)
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .background(
                                        Rectangle()
                                            .foregroundColor(userManager.currentTheme.buttonColor)
                                            .cornerRadius(20)
                                    )
                            }
                        }
                    }
                    .padding()
                }
            }
            .frame(maxWidth: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
            )
        }
        .sheet(isPresented: $showSelectSentencesSheet){
            SelectSentencesOrVocabsView(book: book, vocabulary: vocabulary, selectSentence: true, showSheet: $showSelectSentencesSheet, alreadyLinkedElements: $alreadyLinkedElements)
                .presentationDetents([.height(600), .large])
                .presentationDragIndicator(.automatic)
                .onDisappear(){
                    Task {
                        updatedVocab = try await getVocabFromDatabase()
                        linkedSentences = getLinkedSentences2()
                        alreadyLinkedElements = getLinkedSentences()
                    }
                }
        }
        .sheet(isPresented: $showSelectVocabsSheet){
            SelectSentencesOrVocabsView(book: book, sentence: sentence, selectSentence: false, showSheet: $showSelectVocabsSheet, alreadyLinkedElements: $alreadyLinkedElements)
                .presentationDetents([.height(600), .large])
                .presentationDragIndicator(.automatic)
                .onDisappear(){
                    Task {
                        updatedSentence = try await getSentenceFromDatabase()
                        linkedVocabs = try await getLinkedVocabularies()
                        alreadyLinkedElements = updatedSentence.linkedWords
                    }
                }
        }
        .onAppear() {
            if linkingSentences {
                Task {
                    updatedVocab = try await getVocabFromDatabase()
                    linkedSentences = getLinkedSentences2()
                    alreadyLinkedElements = getLinkedSentences()
                }
            } else {
                Task {
                    updatedSentence = try await getSentenceFromDatabase()
                    linkedVocabs = try await getLinkedVocabularies()
                    alreadyLinkedElements = updatedSentence.linkedWords
                }
            }
        }
    }
    
    // get all linked sentences for a vocabulary, returns array of sentences as strings
    func getLinkedSentences() -> [String] {
        guard let allSentencesInThisBook = sentencesManager.mySentences[book.id] else { return [] }
        var linkedSentences: [String] = []
        for sentence in allSentencesInThisBook {
            if (sentence.linkedWords.contains(updatedVocab.word)){
                linkedSentences.append(sentence.sentence)
            }
        }
        return linkedSentences
    }
    
    // get all linked sentences for a vocabulary, returns array of sentences as sentence objects
    func getLinkedSentences2() -> [Sentence] {
        guard let allSentencesInThisBook = sentencesManager.mySentences[book.id] else { return [] }
        var linkedSentences: [Sentence] = []
        for sentence in allSentencesInThisBook {
            if (sentence.linkedWords.contains(updatedVocab.word)){
                linkedSentences.append(sentence)
            }
        }
        return linkedSentences
    }
    
    // get all linked vocabularies for a sentence, returns an array of vocabularies as vocabulary objects
    func getLinkedVocabularies() async throws -> [Vocabulary] {
        var linkedVocabs: [Vocabulary] = []
        let task = Task {
            for vocab in updatedSentence.linkedWords {
                let v = try await vocabsManager.fetchVocabFromWord(word: vocab)
                linkedVocabs.append(v)
            }
            return linkedVocabs
        }
        let result = try await task.value
        return result
    }
    
    func getVocabFromDatabase() async throws -> Vocabulary {
        let task = Task {
            return try await vocabsManager.fetchVocabFromID(id: vocabulary.id)
        }
        let result = try await task.value
        return result
    }
    
    func getSentenceFromDatabase() async throws -> Sentence {
        let task = Task {
            return try await sentencesManager.fetchSentenceFromID(id: sentence.id)
        }
        let result = try await task.value
        return result
    }
}

struct LinkSentenceOrVocabView_Previews: PreviewProvider {
    static var previews: some View {
        LinkSentenceOrVocabView(book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"),
                                sentence: Sentence(bookID: "bookID", userID: "userID", sentence: "The penguin detective looks out the window from his igloo.", linkedWords: ["vocab1", "vocab2"]),
                                vocabulary: Vocabulary(bookID: "bookID", userID: "userID", word: "penguin", definition: "an animal living in Antartica", note: "penguins live in Antartica"),
                                linkingSentences: false)
        .environmentObject(UserAccountsManager())
        .environmentObject(BookshelvesManager())
        .environmentObject(BooksManager())
        .environmentObject(VocabulariesManager())
        .environmentObject(SentencesManager())
    }
}
