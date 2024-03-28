import SwiftUI

struct SentenceDetailsView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    @Environment(\.dismiss) var dismiss
    
    var book: Book
    var sentence: Sentence
    
    @State var showEditSheet: Bool = false
    
    var body: some View {
        ZStack {
            userManager.currentTheme.bgColor
            VStack (alignment: .leading ,spacing: 20) {
                HStack (alignment: .bottom, spacing: 0) {
                    Label(sentence.sentence,systemImage: "quote.opening")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                    
                    Image(systemName: "quote.closing")
                        .foregroundColor(userManager.currentTheme.primaryAccentColor)
                        .font(.title2)
                }
                
                LinkSentenceOrVocabView(book: book, sentence: sentence, linkingSentences: false)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal){
                Text(sentence.sentence)
                    .foregroundStyle(userManager.currentTheme.fontColor)
                    .lineLimit(1)
            }
            
            ToolbarItem(placement: .topBarTrailing){
                Menu {
                    Button ("Edit") {
                        showEditSheet.toggle()
                    }
                    Button("Delete sentence") {
                        Task {
                            try await sentencesManager.removeSentence(sentenceID: sentence.id)
                        }
                        dismiss()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                        .font(.system(size: 24))
                }
            }
        }
        .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .sheet(isPresented: $showEditSheet){
            NewEditSentenceView(book: book,sentence: sentence, showSheet: $showEditSheet, isEdit: true)
                .presentationDetents([.height(600), .large])
                .presentationDragIndicator(.automatic)
        }
    }
}

struct SentenceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SentenceDetailsView(book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"),
                            sentence: Sentence(bookID: "bookID", userID: "userID", sentence: "The penguin detective looks out the window from his igloo.", linkedWords: ["vocab"]))
        .environmentObject(UserAccountsManager())
        .environmentObject(BookshelvesManager())
        .environmentObject(BooksManager())
        .environmentObject(VocabulariesManager())
        .environmentObject(SentencesManager())
    }
}
