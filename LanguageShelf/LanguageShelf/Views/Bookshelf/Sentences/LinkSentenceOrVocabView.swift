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
    
    var linkingSentences = true // true if vocab entry wants to link sentences, false if sentence entry wants to link vocab
    
    @State var showSelectSentencesSheet = false
    @State var showSelectVocabsSheet = false
    
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
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                        .bold()
                })
            }
            
            ScrollView {
                if linkingSentences {
                    if let sentencesInThisBook = sentencesManager.mySentences[book.id] {
                        VStack {
                            ForEach(sentencesInThisBook) { sent in
                                if (sent.linkedWords.contains(vocabulary.word)){
                                    Text(sent.sentence)
                                        .foregroundStyle(userManager.currentTheme.fontColor)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                                        )
                                }
                            }
                        }
                        .padding()
                    }
                } else {
                    VStack {
                        ForEach(sentence.linkedWords, id: \.self) { vocab in
                            Text(vocab)
                                .foregroundStyle(userManager.currentTheme.fontColor)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                                )
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
            SelectSentencesOrVocabsView(book: book, selectSentence: true, showSheet: $showSelectSentencesSheet)
                .presentationDetents([.height(600), .large])
                .presentationDragIndicator(.automatic)
        }
        .sheet(isPresented: $showSelectVocabsSheet){
            SelectSentencesOrVocabsView(book: book, selectSentence: false, showSheet: $showSelectVocabsSheet)
                .presentationDetents([.height(600), .large])
                .presentationDragIndicator(.automatic)
        }
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
