import SwiftUI

struct VocabularyCardView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    
    var vocabulary: Vocabulary
    
    var body: some View {
        VStack (spacing: 0) {
            HStack {
                Text(vocabulary.word)
                    .foregroundStyle(userManager.currentTheme.fontColor)
                Spacer()
                Image(systemName: "arrowtriangle.right.fill")
                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
            }
            .padding()
            .background(userManager.currentTheme.bgColor)
            Divider()
                .frame(minHeight: 2)
                .background(userManager.currentTheme.primaryAccentColor)
        }
    }
}

struct VocabularyCardView_Previews: PreviewProvider {
    static var previews: some View {
        VocabularyCardView(vocabulary: Vocabulary(bookID: "bookID", userID: "userID", word: "penguin", definition: "an animal living in Antartica", note: "penguins live in Antartica"))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
    }
}
