import SwiftUI

struct EditVocabularyView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    
    var book: Book
    var vocabulary: Vocabulary
    
    @Binding var isEdit: Bool
    
    @Binding var editVocab: String
    @Binding var editDefinition: String
    @Binding var editNote: String
    
    @State var existingVocabAlert: Bool = false
    @State var emptyFieldAlert: Bool = false
    
    var body: some View {
        ZStack {
            userManager.currentTheme.bgColor
            
            VStack(spacing: 20) {
                CustomTextField(label: "Vocabulary: ", placeholder: "Vocabulary", textValue: $editVocab)
                ScrollableTextField(label: "Definition: ", placeholder: "Definition", textValue: $editDefinition)
                ScrollableTextField(label: "Notes: ", placeholder: "Notes", textValue: $editNote, optional: true)
                
                HStack {
                    Button2(label: "Cancel") {
                        isEdit.toggle()
                    }
                    Button1(label: "Save") {
                        Task {
                            do {
                                try await vocabsManager.updateVocabulary(bookID: book.id, vocabID: vocabulary.id, newWord: editVocab, newDefinition: editDefinition, newNote: editNote)
                                isEdit.toggle()
                            } catch DataErrors.existingNameError {
                                existingVocabAlert.toggle()
                            } catch DataErrors.emptyNameError {
                                emptyFieldAlert.toggle()
                            }
                        }
                    }
                }
            }
        }
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

struct EditVocabularyView_Previews: PreviewProvider {
    static var previews: some View {
        EditVocabularyView(book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"),
                           vocabulary: Vocabulary(bookID: "bookID", userID: "userID", word: "penguin", definition: "an animal living in Antartica", note: "penguins live in Antartica"),
                           isEdit: .constant(true),
                           editVocab: .constant(""),
                           editDefinition: .constant(""),
                           editNote: .constant(""))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
    }
}
