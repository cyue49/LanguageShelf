import SwiftUI

struct VocabularyDetailsView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    @Environment(\.dismiss) var dismiss
    
    var book: Book
    var vocabulary: Vocabulary
    
    @State var updatedVocab: Vocabulary = Vocabulary(id: "", bookID: "", userID: "", word: "", definition: "")
    @State var showEditSheet: Bool = false
    
    var body: some View {
        ZStack {
            userManager.currentTheme.bgColor
            ScrollView {
                VStack (alignment: .leading ,spacing: 20) {
                    HStack {
                        Image(systemName: "text.book.closed.fill")
                            .foregroundColor(userManager.currentTheme.primaryAccentColor)
                            .font(.system(size: 30))
                        
                        Text(updatedVocab.word)
                            .font(.title)
                            .bold()
                            .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                    }
                    
                    Text("Definition:")
                        .font(.subheadline)
                        .foregroundStyle(userManager.currentTheme.fontColor)
                    VStack {
                        Text(updatedVocab.definition)
                            .foregroundStyle(userManager.currentTheme.fontColor)
                            .padding()
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                    )
                    
                    Text("Notes:")
                        .font(.subheadline)
                        .foregroundStyle(userManager.currentTheme.fontColor)
                    VStack {
                        Text(updatedVocab.note)
                            .foregroundStyle(userManager.currentTheme.fontColor)
                            .padding()
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                    )
                    
                    LinkSentenceOrVocabView(book: book, vocabulary: vocabulary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal){
                Text(updatedVocab.word)
                    .foregroundStyle(userManager.currentTheme.fontColor)
            }
            
            ToolbarItem(placement: .topBarTrailing){
                Menu {
                    Button ("Edit") {
                        showEditSheet.toggle()
                    }
                    Button("Delete vocabulary") {
                        Task {
                            try await vocabsManager.removeVocabulary(vocabularyID: vocabulary.id)
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
            NewEditVocabularySheetView(book: book, vocabulary: updatedVocab, showSheet: $showEditSheet, isEdit: true)
                .presentationDetents([.height(600), .large])
                .presentationDragIndicator(.automatic)
                .onDisappear(){
                    Task {
                        updatedVocab = try await getVocabFromDatabase()
                    }
                }
        }
        .onAppear(){
            Task {
                updatedVocab = try await getVocabFromDatabase()
            }
        }
    }
    
    func getVocabFromDatabase() async throws -> Vocabulary {
        let task = Task {
            return try await vocabsManager.fetchVocabFromID(id: vocabulary.id)
        }
        let result = try await task.value
        return result
    }
}

struct VocabularyDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        VocabularyDetailsView(book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"),
                              vocabulary: Vocabulary(bookID: "bookID", userID: "userID", word: "penguin", definition: "an animal living in Antartica", note: "penguins live in Antartica"))
        .environmentObject(UserAccountsManager())
        .environmentObject(BookshelvesManager())
        .environmentObject(BooksManager())
        .environmentObject(VocabulariesManager())
        .environmentObject(SentencesManager())
    }
}
