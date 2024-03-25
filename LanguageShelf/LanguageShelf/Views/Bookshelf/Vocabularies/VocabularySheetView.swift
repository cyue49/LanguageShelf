import SwiftUI

struct VocabularySheetView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    
    var book: Book
    
    @Binding var showVocabulary: Bool
    
    @State var newWord: String = ""
    @State var newDefinition: String = ""
    @State var newNote: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                userManager.currentTheme.bgColor
                
                VStack(spacing: 20) {
                    CustomTextField(label: "Vocabulary: ", placeholder: "Vocabulary", textValue: $newWord)
                    CustomTextField(label: "Definition: ", placeholder: "Definition", textValue: $newDefinition)
                    ScrollableTextField(label: "Note: ", placeholder: "Note", textValue: $newNote, optional: true)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showVocabulary.toggle()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        // todo
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Adding Vocabulary")
                        .foregroundStyle(userManager.currentTheme.fontColor)
                }
            }
            .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct VocabularySheetView_Previews: PreviewProvider {
    static var previews: some View {
        VocabularySheetView(book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"), 
                            showVocabulary: .constant(true))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
    }
}
