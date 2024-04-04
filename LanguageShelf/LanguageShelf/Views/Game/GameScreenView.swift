import SwiftUI

struct GameScreenView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    @State var currentGameSet: [String : String] = [:] // dictionary of matching words and definitions (key: word, value: matching definition)
    @State var currentGameItems: [(String, Int)] = [] // array of tuples (word or definition string, int where 0 = word and 1 = definition)
    
    var body: some View {
        NavigationStack {
            ZStack {
                userManager.currentTheme.bgColor
                    .ignoresSafeArea()
                VStack {
                    ScrollView {
                        ForEach(currentGameItems, id: \.0) { (item, type) in
                            GameCardView(gameCardItem: item, isDefinition: (type == 0) ? false : true)
                        }
                    }
                    .padding()
                }
            }
            .onAppear(){
                // reset current game set and current game items on appear
                currentGameSet = [:]
                currentGameItems = []
                
                // get all of user's vocabs, shuffled
                let allVocabs = vocabsManager.getVocabsOfAllBooks().shuffled()
                
                // choose first 5 Vocabulary, put words and definitions as key value pairs in dictionary, and put word/definition strings in current game items array
                if (allVocabs.count <= 5) {
                    for vocab in allVocabs {
                        currentGameSet[vocab.word] = vocab.definition
                        currentGameItems.append((vocab.word, 0))
                        currentGameItems.append((vocab.definition, 1))
                    }
                } else {
                    for i in 0...4 {
                        currentGameSet[allVocabs[i].word] = allVocabs[i].definition
                        currentGameItems.append((allVocabs[i].word, 0))
                        currentGameItems.append((allVocabs[i].definition, 1))
                    }
                }
                
                // shuffle the game items
                currentGameItems.shuffle()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    ZStack {
                        VStack {
                            switch userManager.currentTheme.name {
                            case "default":
                                Image(.logo1024Blue)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case "light":
                                Image(.logo1024Light)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case "dark":
                                Image(.logo1024Dark)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case "green":
                                Image(.logo1024Green)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            default:
                                Text("LanguageShelf")
                                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack {
                            Text("Game Screen")
                                .foregroundStyle(userManager.currentTheme.fontColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameScreenView()
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
            .environmentObject(SentencesManager())
    }
}
