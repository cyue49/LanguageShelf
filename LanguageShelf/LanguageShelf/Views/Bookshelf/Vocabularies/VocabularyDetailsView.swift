import SwiftUI

struct VocabularyDetailsView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    
    var book: Book
    var vocabulary: Vocabulary
    
    @State var isEdit: Bool = false
    
    @State var editVocab: String = ""
    @State var editDefinition: String = ""
    @State var editNote: String = ""
    
    @State var existingVocabAlert: Bool = false
    @State var emptyFieldAlert: Bool = false
    
    var body: some View {
        ZStack {
            userManager.currentTheme.bgColor
            VStack (alignment: .leading ,spacing: 20) {
                if !isEdit {
                    HStack {
                        Image(systemName: "text.book.closed.fill")
                            .foregroundColor(userManager.currentTheme.primaryAccentColor)
                            .font(.system(size: 30))
                        
                        Text(vocabulary.word)
                            .font(.title)
                            .bold()
                            .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                    }
                    
                    Text("Definition:")
                        .font(.subheadline)
                        .foregroundStyle(userManager.currentTheme.fontColor)
                    ScrollView {
                        Text(vocabulary.definition)
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
                    ScrollView {
                        Text(vocabulary.note)
                            .foregroundStyle(userManager.currentTheme.fontColor)
                            .padding()
                            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                        
                        
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                    )
                    Button1(label: "Edit") {
                        editVocab = vocabulary.word
                        editDefinition = vocabulary.definition
                        editNote = vocabulary.note
                        isEdit.toggle()
                    }
                } else {
                    CustomTextField(label: "Vocabulary: ", placeholder: "Vocabulary", textValue: $editVocab, optional: true)
                    ScrollableTextField(label: "Definition: ", placeholder: "Definition", textValue: $editDefinition, optional: true)
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
                    .padding([.bottom], 30)
                }
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal){
                Text(vocabulary.word)
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

struct VocabularyDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        VocabularyDetailsView(book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"),
                              vocabulary: Vocabulary(bookID: "bookID", userID: "userID", word: "penguin", definition: "an animal living in Antartica", note: "penguins live in Antartica"))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
    }
}
