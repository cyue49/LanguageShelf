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
    
    @State var existingVocabAlert: Bool = false
    @State var emptyFieldAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                userManager.currentTheme.bgColor
                
                VStack(spacing: 20) {
                    CustomTextField(label: "Vocabulary: ", placeholder: "Vocabulary", textValue: $newWord)
                    ScrollableTextField(label: "Definition: ", placeholder: "Definition", textValue: $newDefinition)
                    ScrollableTextField(label: "Notes: ", placeholder: "Notes", textValue: $newNote, optional: true)
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
                        Task {
                            do {
                                try await vocabsManager.addNewVocabulary(bookID: book.id, newWord: newWord, newDefinition: newDefinition, newNote: newNote)
                                showVocabulary.toggle()
                            } catch DataErrors.existingNameError {
                                existingVocabAlert.toggle()
                            } catch DataErrors.emptyNameError {
                                emptyFieldAlert.toggle()
                            }
                        }
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Adding Vocabulary")
                        .foregroundStyle(userManager.currentTheme.fontColor)
                }
            }
            .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .alert("You have already created this vocabulary.", isPresented: $existingVocabAlert){
                Button("Ok", role: .cancel) {
                    existingVocabAlert = false
                }
            }
            .alert("You must enter a vocabulary and a definition.", isPresented: $emptyFieldAlert){
                Button("Ok", role: .cancel) {
                    emptyFieldAlert = false
                }
            }
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
