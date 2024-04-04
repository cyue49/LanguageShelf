import SwiftUI

struct GameCardView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    var vocabItem: Vocabulary
    var isDefinition: Bool = false
    
    @State var isSelected: Bool = false
    
    var body: some View {
        HStack (alignment: .center, spacing: 10) {
            if isDefinition {
                Image(systemName: "text.book.closed.fill")
                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                    .font(.system(size: 28))
                Spacer()
                Text(vocabItem.definition)
                Spacer()
            } else {
                Image(systemName: "character.book.closed.fill")
                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                    .font(.system(size: 28))
                Spacer()
                Text(vocabItem.word)
                Spacer()
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundStyle(isSelected ? userManager.currentTheme.bgColor : userManager.currentTheme.fontColor)
        .bold()
        .background(isSelected ? userManager.currentTheme.primaryAccentColor : userManager.currentTheme.buttonColor)
        .cornerRadius(30)
    }
}

struct GameCardView_Previews: PreviewProvider {
    static var previews: some View {
        GameCardView(vocabItem: Vocabulary(bookID: "bookID", userID: "userID", word: "penguin", definition: "a large flightless seabird of the southern hemisphere, with black upper parts and white underparts and wings developed into flippers for swimming under water.", note: "penguins live in Antartica"))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
            .environmentObject(SentencesManager())
    }
}
