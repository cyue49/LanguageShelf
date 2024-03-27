import SwiftUI

struct VocabularyCardView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    
    var vocabulary: Vocabulary = Vocabulary(id: "", bookID: "", userID: "", word: "", definition: "")
    var sentence: Sentence = Sentence(id: "", bookID: "", userID: "", sentence: "", linkedWords: [])
    
    var isVocab: Bool = true
    
    var body: some View {
        VStack (spacing: 0) {
            HStack {
                if isVocab { // vocabulary
                    Text(vocabulary.word)
                        .foregroundStyle(userManager.currentTheme.fontColor)
                } else { // sentence
                    Text(sentence.sentence)
                        .foregroundStyle(userManager.currentTheme.fontColor)
                        .lineLimit(1)
                }
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
        VocabularyCardView(vocabulary: Vocabulary(bookID: "bookID", userID: "userID", word: "penguin", definition: "an animal living in Antartica", note: "penguins live in Antartica"),
        sentence: Sentence(bookID: "bookID", userID: "userID", sentence: "The penguin detective looks out the window from his igloo.", linkedWords: ["vocabID"]))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
    }
}
