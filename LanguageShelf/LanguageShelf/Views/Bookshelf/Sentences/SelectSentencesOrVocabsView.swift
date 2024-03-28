import SwiftUI

struct SelectSentencesOrVocabsView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    var book: Book
    
    var selectSentence = true // true for selecting sentences, false for selecting vocabularies
    
    @Binding var showSheet: Bool
    
    var alreadyLinkedElements: [String]
    
    @State private var searchText = ""
    
    // filtered vocabs from search bar
    var filteredVocabList: [Vocabulary] {
        guard let allVocabList = vocabsManager.myVocabularies[book.id] else { return [] }
        if searchText.isEmpty{
            return allVocabList
        }
        var filteredVocabList: [Vocabulary] = []
        for vocab in allVocabList {
            if vocab.word.lowercased().contains(searchText.lowercased()){
                filteredVocabList.append(vocab)
            }
        }
        return filteredVocabList
    }
    
    // filtered sentences from search bar
    var filteredSentenceList: [Sentence] {
        guard let allSentenceList = sentencesManager.mySentences[book.id] else { return [] }
        if searchText.isEmpty{
            return allSentenceList
        }
        var filteredSentenceList: [Sentence] = []
        for sentence in allSentenceList {
            if sentence.sentence.lowercased().contains(searchText.lowercased()){
                filteredSentenceList.append(sentence)
            }
        }
        return filteredSentenceList
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                userManager.currentTheme.bgColor
                    .ignoresSafeArea()
                
                VStack (spacing: 20) {
                    if selectSentence { // vocab selects sentence
                        if sentencesManager.mySentences[book.id] == nil { // No sentence in this book
                            Text("You don't have any sentence in this book.")
                                .foregroundStyle(userManager.currentTheme.fontColor)
                                .frame(maxHeight: .infinity)
                        } else {
                            ForEach(filteredSentenceList) { sentence in
                                if !alreadyLinkedElements.contains(sentence.sentence){
                                    CheckboxStyle1(label: sentence.sentence, checked: .constant(false))
                                }
                            }
                        }
                    } else { // sentence selects vocab
                        if vocabsManager.myVocabularies[book.id] == nil { // No vocab in this book
                            Text("You don't have any vocabulary in this book.")
                                .foregroundStyle(userManager.currentTheme.fontColor)
                                .frame(maxHeight: .infinity)
                        } else {
                            ForEach(filteredVocabList) { vocab in
                                if !alreadyLinkedElements.contains(vocab.word){
                                    CheckboxStyle1(label: vocab.word, checked: .constant(false))
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding()
                .searchable(text: $searchText)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showSheet.toggle()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button ("Add") {
                        if selectSentence {
                            // todo
                        } else {
                            // todo
                        }
                    }
                }
            }
            .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct SelectSentencesOrVocabsView_Previews: PreviewProvider {
    static var previews: some View {
        SelectSentencesOrVocabsView(book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"),
                                    selectSentence: true,
                                    showSheet: .constant(true),
                                    alreadyLinkedElements: [])
        .environmentObject(UserAccountsManager())
        .environmentObject(BookshelvesManager())
        .environmentObject(BooksManager())
        .environmentObject(VocabulariesManager())
        .environmentObject(SentencesManager())
    }
}
