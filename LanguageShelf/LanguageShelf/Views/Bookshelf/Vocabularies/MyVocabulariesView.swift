import SwiftUI

struct VocabulariesView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    var book: Book
    
    @State var selectedTab: Int = 0 // 0 for vocabulary, 1 for sentence
    @State var showVocabSheet: Bool = false
    @State var showSentenceSheet: Bool = false
    
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
                
                VStack (spacing: 0) {
                    TwoChoicesPicker(choice: $selectedTab, choice1: "Vocabulary", choice2: "Sentence")
                        .padding(6)
                    
                    if selectedTab == 0 { // vocabulary
                        if vocabsManager.myVocabularies[book.id] == nil { // No vocab in this book
                            Text("You don't have any vocabulary in this book.")
                                .foregroundStyle(userManager.currentTheme.fontColor)
                                .frame(maxHeight: .infinity)
                        } else {
                            List {
                                ForEach(filteredVocabList) { vocab in
                                    VocabularyCardView(vocabulary: vocab)
                                        .overlay(
                                            NavigationLink("", destination: VocabularyDetailsView(book: book ,vocabulary: vocab))
                                                .opacity(0)
                                        )
                                }
                                .listRowInsets(.init())
                            }
                            .listStyle(.plain)
                        }
                    } else { // sentence
                        if sentencesManager.mySentences[book.id] == nil { // No sentence in this book
                            Text("You don't have any sentence in this book.")
                                .foregroundStyle(userManager.currentTheme.fontColor)
                                .frame(maxHeight: .infinity)
                        } else {
                            List {
                                ForEach(filteredSentenceList) { sentence in
                                    VocabularyCardView(sentence: sentence, isVocab: false)
                                        .overlay(
                                            NavigationLink("", destination: SentenceDetailsView(book: book ,sentence: sentence))
                                                .opacity(0)
                                        )
                                }
                                .listRowInsets(.init())
                            }
                            .listStyle(.plain)
                        }
                    }
                }
                .searchable(text: $searchText)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal){
                    Text(book.title)
                        .foregroundStyle(userManager.currentTheme.fontColor)
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        if selectedTab == 0 {
                            showVocabSheet.toggle()
                        } else {
                            showSentenceSheet.toggle()
                        }
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                            .bold()
                    })
                }
            }
            .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $showVocabSheet){
                NewEditVocabularySheetView(book: book, showSheet: $showVocabSheet, isEdit: false)
                    .presentationDetents([.height(600), .large])
                    .presentationDragIndicator(.automatic)
            }
            .sheet(isPresented: $showSentenceSheet){
                NewEditSentenceView(book: book, showSheet: $showSentenceSheet, isEdit: false)
                    .presentationDetents([.height(600), .large])
                    .presentationDragIndicator(.automatic)
            }
        }
    }
}

struct VocabulariesView_Previews: PreviewProvider {
    static var previews: some View {
        VocabulariesView(book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
            .environmentObject(SentencesManager())
    }
}
