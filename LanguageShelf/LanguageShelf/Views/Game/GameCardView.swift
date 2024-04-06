import SwiftUI

struct GameCardView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    var gameCardItem: String
    var isDefinition: Bool = false
    
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack {
            HStack (alignment: .center, spacing: 10) {
                if isDefinition {
                    Image(systemName: "text.book.closed.fill")
                        .foregroundStyle(isSelected ? userManager.currentTheme.bgColor : userManager.currentTheme.primaryAccentColor)
                        .font(.system(size: 28))
                    Spacer()
                    Text(gameCardItem)
                    Spacer()
                } else {
                    Spacer()
                    Text(gameCardItem)
                    Spacer()
                    Image(systemName: "character.book.closed.fill")
                        .foregroundStyle(isSelected ? userManager.currentTheme.bgColor : userManager.currentTheme.primaryAccentColor)
                        .font(.system(size: 28))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(isSelected ? userManager.currentTheme.bgColor : userManager.currentTheme.fontColor)
            .bold()
            .background(isSelected ? userManager.currentTheme.primaryAccentColor : userManager.currentTheme.buttonColor)
            .cornerRadius(30)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(userManager.currentTheme.primaryAccentColor,
                            lineWidth: 2)
            )
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 6)
    }
}

struct GameCardView_Previews: PreviewProvider {
    static var previews: some View {
        GameCardView(gameCardItem: "penguin", isSelected: .constant(false))
        //        GameCardView(gameCardItem: "a large flightless seabird of the southern hemisphere, with black upper parts and white underparts and wings developed into flippers for swimming under water.")
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
            .environmentObject(SentencesManager())
    }
}
