import SwiftUI

struct VocabulariesView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    
    var book: Book
    
    @State var selectedTab: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack {
                userManager.currentTheme.bgColor
                
                VStack {
                    TwoChoicesPicker(choice: $selectedTab, choice1: "Vocabulary", choice2: "Sentence")
                        .padding(.horizontal, 6)
                        .padding(.top, 11)
                    
                    if selectedTab == 0 {
                        List {
                            VocabularyCardView(vocabulary: Vocabulary(bookID: "bookID", userID: "userID", word: "penguin", definition: "an animal living in Antartica", note: "penguins live in Antartica"))
                                .listRowInsets(.init())
                            VocabularyCardView(vocabulary: Vocabulary(bookID: "bookID", userID: "userID", word: "polar bear", definition: "an animal living in Antartica", note: "penguins live in Antartica"))
                                .listRowInsets(.init())
                        }
                        .listStyle(.plain)
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
                        // Todo
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                            .bold()
                    })
                }
            }
            .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
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
