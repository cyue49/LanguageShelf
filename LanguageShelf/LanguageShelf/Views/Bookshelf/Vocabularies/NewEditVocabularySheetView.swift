import SwiftUI

struct NewEditVocabularySheetView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    var book: Book
    var vocabulary: Vocabulary = Vocabulary(id: "", bookID: "", userID: "", word: "", definition: "", note: "")
    
    @Binding var showSheet: Bool
    var isEdit: Bool
    
    @State var vocabField: String = ""
    @State var definitionField: String = ""
    @State var noteField: String = ""
    
    @State var existingVocabAlert: Bool = false
    @State var emptyFieldAlert: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                userManager.currentTheme.bgColor
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 20) {
                        CustomTextField(label: "Vocabulary: ", placeholder: "Vocabulary", textValue: $vocabField)
                        ScrollableTextField(label: "Definition: ", placeholder: "Definition", textValue: $definitionField)
                        ScrollableTextField(label: "Notes: ", placeholder: "Notes", textValue: $noteField, optional: true)
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showSheet.toggle()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        Task {
                            do {
                                if isEdit {
                                    updateSentencesLinkedVocab()
                                    try await vocabsManager.updateVocabulary(bookID: book.id, vocabID: vocabulary.id, newWord: vocabField, newDefinition: definitionField, newNote: noteField)
                                } else {
                                    try await vocabsManager.addNewVocabulary(bookID: book.id, newWord: vocabField, newDefinition: definitionField, newNote: noteField)
                                }
                                showSheet.toggle()
                            } catch DataErrors.existingNameError {
                                existingVocabAlert.toggle()
                            } catch DataErrors.emptyNameError {
                                emptyFieldAlert.toggle()
                            }
                        }
                    }, label: {
                        if isEdit {
                            Text("Save")
                        } else {
                            Text("Add")
                        }
                    })
                }
            }
            .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .onAppear(){
            if isEdit {
                vocabField = vocabulary.word
                definitionField = vocabulary.definition
                noteField = vocabulary.note
            } else {
                vocabField = ""
                definitionField = ""
                noteField = ""
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
        .onChange(of: vocabField) {
            if vocabField.count > 18 {
                vocabField = String(vocabField.prefix(18))
            }
        }
        .onChange(of: definitionField) {
            if definitionField.count > 100 {
                definitionField = String(definitionField.prefix(100))
            }
        }
        .onChange(of: noteField) {
            if noteField.count > 500 {
                noteField = String(noteField.prefix(500))
            }
        }
    }
    
    func updateSentencesLinkedVocab() {
        guard let allSentencesInThisBook = sentencesManager.mySentences[book.id] else { return }
        Task {
            for sentence in allSentencesInThisBook {
                if sentence.linkedWords.contains(vocabulary.word){
                    var updatedLinkedWords = sentence.linkedWords
                    if let index = updatedLinkedWords.firstIndex(of: vocabulary.word){
                        updatedLinkedWords.remove(at: index)
                    }
                    updatedLinkedWords.append(vocabField)
                    try await sentencesManager.updateSentence(bookID: book.id, sentenceID: sentence.id, newSentence: sentence.sentence, linkedWords: updatedLinkedWords)
                }
            }
        }
    }
}

struct NewEditVocabularySheetView_Previews: PreviewProvider {
    static var previews: some View {
        NewEditVocabularySheetView(book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"),
                           vocabulary: Vocabulary(bookID: "bookID", userID: "userID", word: "penguin", definition: "an animal living in Antartica", note: "penguins live in Antartica"),
                                   showSheet: .constant(true),
                                   isEdit: true)
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
            .environmentObject(SentencesManager())
    }
}
