import SwiftUI

struct VocabulariesView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    
    var book: Book
    
    var body: some View {
        NavigationStack {
            ZStack {
                userManager.currentTheme.bgColor
                Text("Vocabularies")
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
