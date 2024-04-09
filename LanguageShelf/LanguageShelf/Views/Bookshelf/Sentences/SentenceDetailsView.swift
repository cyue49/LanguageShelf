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
    
    @State var updatedSentence: Sentence = Sentence(id: "", bookID: "", userID: "", sentence: "", linkedWords: [])
    @State var showEditSheet: Bool = false
    @State var showConfirmDeleteAlert: Bool = false
    
    var body: some View {
        ZStack {
            userManager.currentTheme.bgColor
            VStack (alignment: .leading ,spacing: 20) {
                HStack (alignment: .bottom, spacing: 0) {
                    Label(updatedSentence.sentence,systemImage: "quote.opening")
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
                Text(updatedSentence.sentence)
                    .foregroundStyle(userManager.currentTheme.fontColor)
                    .lineLimit(1)
            }
            
            ToolbarItem(placement: .topBarTrailing){
                Menu {
                    Button ("Edit") {
                        showEditSheet.toggle()
                    }
                    Button("Delete sentence") {
                        showConfirmDeleteAlert.toggle()
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
            NewEditSentenceView(book: book,sentence: updatedSentence, showSheet: $showEditSheet, isEdit: true)
                .presentationDetents([.height(600), .large])
                .presentationDragIndicator(.automatic)
                .onDisappear(){
                    Task {
                        updatedSentence = try await getSentenceFromDatabase()
                    }
                }
        }
        .onAppear(){
            Task {
                updatedSentence = try await getSentenceFromDatabase()
            }
        }
        .alert("Confirm Delete", isPresented: $showConfirmDeleteAlert) {
            Button("Delete", role: .destructive){
                Task {
                    try await sentencesManager.removeSentence(sentenceID: sentence.id)
                }
                dismiss()
            }
            Button("Cancel", role: .cancel){}
        } message: {
            Text("Are you sure you want to delete this sentence?")
        }
    }
    
    func getSentenceFromDatabase() async throws -> Sentence {
        let task = Task {
            return try await sentencesManager.fetchSentenceFromID(id: sentence.id)
        }
        let result = try await task.value
        return result
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
