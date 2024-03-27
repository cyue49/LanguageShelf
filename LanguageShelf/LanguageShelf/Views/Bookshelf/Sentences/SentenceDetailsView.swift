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
            Text("Sentence details view")
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
                    Button("Delete Book") {
                        Task {
                            //
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
//            NewEditVocabularySheetView(book: book, vocabulary: vocabulary, showSheet: $showEditSheet, isEdit: true)
//                .presentationDetents([.height(600), .large])
//                .presentationDragIndicator(.automatic)
        }
    }
}

struct SentenceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SentenceDetailsView(book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"),
                            sentence: Sentence(bookID: "bookID", userID: "userID", sentence: "The penguin detective looks out the window from his igloo.", linkedWords: ["vocabID"]))
        .environmentObject(UserAccountsManager())
        .environmentObject(BookshelvesManager())
        .environmentObject(BooksManager())
        .environmentObject(VocabulariesManager())
        .environmentObject(SentencesManager())
    }
}
