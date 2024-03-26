import SwiftUI

struct VocabulariesView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    
    var book: Book
    
    @State var selectedTab: Int = 0
    @State var showVocabSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                userManager.currentTheme.bgColor
                
                VStack (spacing: 0) {
                    TwoChoicesPicker(choice: $selectedTab, choice1: "Vocabulary", choice2: "Sentence")
                        .padding(6)
                    
                    if selectedTab == 0 {
                        if vocabsManager.myVocabularies[book.id] == nil { // No vocab in this book
                            Text("You don't have any vocabulary in this book.")
                                .foregroundStyle(userManager.currentTheme.fontColor)
                                .frame(maxHeight: .infinity)
                        } else {
                            List {
                                ForEach(vocabsManager.myVocabularies[book.id]!) { vocab in
                                    VocabularyCardView(vocabulary: vocab)
                                        .overlay(
                                            NavigationLink("", destination: VocabularyDetailsView(book: book ,vocabulary: vocab))
                                                .opacity(0)
                                        )
                                }
                                .listRowInsets(.init())
                            }
                            .listStyle(.plain)
                        }
                    } else {
                        List {
                            VocabularyCardView(vocabulary: Vocabulary(bookID: "bookID", userID: "userID", word: "penguin", definition: "an animal living in Antartica", note: "penguins live in Antartica"))
                                .listRowInsets(.init())
                        }
                        .frame( maxWidth: .infinity)
                        .listStyle(.plain)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal){
                    Text(book.title)
                        .foregroundStyle(userManager.currentTheme.fontColor)
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        if selectedTab == 0 {
                            showVocabSheet.toggle()
                        } else {
                            // todo sentence part
                        }
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                            .bold()
                    })
                }
            }
            .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .sheet(isPresented: $showVocabSheet){
                NewEditVocabularySheetView(book: book, showSheet: $showVocabSheet, isEdit: false)
                    .presentationDetents([.height(600), .large])
                    .presentationDragIndicator(.automatic)
            }
        }
    }
}

struct VocabulariesView_Previews: PreviewProvider {
    static var previews: some View {
        VocabulariesView(book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
    }
}
