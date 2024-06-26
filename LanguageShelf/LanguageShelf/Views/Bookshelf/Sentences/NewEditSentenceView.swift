import SwiftUI

struct NewEditSentenceView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    var book: Book
    var sentence: Sentence = Sentence(id: "", bookID: "", userID: "", sentence: "", linkedWords: [])
    
    @Binding var showSheet: Bool
    var isEdit: Bool
    
    @State var sentenceField: String = ""
    @State var linkedWords: [String] = []
    
    @State var existingSentenceAlert: Bool = false
    @State var emptyFieldAlert: Bool = false
    
    var body: some View {
        NavigationStack{
            ZStack {
                userManager.currentTheme.bgColor
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 20) {
                        ScrollableTextField(label: "Sentence: ", placeholder: "Sentence", textValue: $sentenceField)
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
                                    try await sentencesManager.updateSentence(bookID: book.id, sentenceID: sentence.id, newSentence: sentenceField, linkedWords: linkedWords)
                                } else {
                                    try await sentencesManager.addNewSentence(bookID: book.id, newSentence: sentenceField, linkedWords: linkedWords)
                                }
                                showSheet.toggle()
                            } catch DataErrors.existingNameError {
                                existingSentenceAlert.toggle()
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
                sentenceField = sentence.sentence
                linkedWords = sentence.linkedWords
            } else {
                sentenceField = ""
                linkedWords = []
            }
        }
        .alert("You have already created this sentence.", isPresented: $existingSentenceAlert){
            Button("Ok", role: .cancel) {
                existingSentenceAlert = false
            }
        }
        .alert("You must enter a sentence.", isPresented: $emptyFieldAlert){
            Button("Ok", role: .cancel) {
                emptyFieldAlert = false
            }
        }
        .onChange(of: sentenceField) {
            if sentenceField.count > 190 {
                sentenceField = String(sentenceField.prefix(190))
            }
        }
    }
}

struct NewEditSentenceView_Previews: PreviewProvider {
    static var previews: some View {
        NewEditSentenceView(book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"),
                            sentence: Sentence(bookID: "bookID", userID: "userID", sentence: "The penguin detective looks out the window from his igloo.", linkedWords: ["vocabID"]),
                                   showSheet: .constant(true),
                                   isEdit: true)
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
            .environmentObject(SentencesManager())
    }
}
