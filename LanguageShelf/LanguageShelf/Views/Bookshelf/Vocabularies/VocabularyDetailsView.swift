import SwiftUI

struct VocabularyDetailsView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    
    var vocabulary: Vocabulary
    
    var body: some View {
        VStack {
            Text(vocabulary.word)
            Text("Definition")
            Text(vocabulary.definition)
            Text("Notes")
            Text(vocabulary.note)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal){
                Text(vocabulary.word)
                    .foregroundStyle(userManager.currentTheme.fontColor)
            }
            
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                    // Todo
                }, label: {
                    Text("Edit")
                        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                        .bold()
                })
            }
        }
        .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

struct VocabularyDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        VocabularyDetailsView(vocabulary: Vocabulary(bookID: "bookID", userID: "userID", word: "penguin", definition: "an animal living in Antartica", note: "penguins live in Antartica"))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
    }
}
