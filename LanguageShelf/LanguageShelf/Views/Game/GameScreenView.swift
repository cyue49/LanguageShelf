import SwiftUI

struct GameScreenView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    @State var currentGameSet: [String : String] = [:] // dictionary of matching words and definitions (key: word, value: matching definition)
    @State var currentGameItems: [(String, Int)] = [] // array of tuples (word or definition string, int where 0 = word and 1 = definition)
    
    @State var selection1: (String, Int)?
    @State var selection2: (String, Int)?
    
    @State var itemSelected: [Bool] = [false, false, false, false, false, false, false, false, false, false]
    
    @State var correct: Bool = false
    
    @State var showIncorrectAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                userManager.currentTheme.bgColor
                    .ignoresSafeArea()
                VStack {
                    ScrollView {
                        ForEach((0..<currentGameItems.count), id: \.self) { i in
                            GameCardView(gameCardItem: currentGameItems[i].0, isDefinition: (currentGameItems[i].1 == 0) ? false : true, isSelected: $itemSelected[i])
                                .onTapGesture {
                                    if selection1 == nil {
                                        selection1 = currentGameItems[i]
                                        itemSelected[i].toggle()
                                    } else if selection2 == nil {
                                        selection2 = currentGameItems[i]
                                        itemSelected[i].toggle()
                                        checkAnswer()
                                    }
                                }
                        }
                    }
                    .padding()
                }
            }
            .onAppear(){
                prepareGame()
            }
            .alert("Incorrect! Please try again.", isPresented: $showIncorrectAlert){
                Button("Ok", role: .cancel) {
                    resetGameState()
                    showIncorrectAlert = false
                }
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
    
    func prepareGame() {
        // reset game states
        currentGameSet = [:]
        currentGameItems = []
        resetGameState()
        
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
    
    func checkAnswer() {
        guard selection1 != nil && selection2 != nil else { return }
        if selection1!.1 == 0 { // selection 1 is word, selection 2 is definition
            if currentGameSet[selection1!.0] == selection2!.0 { // correct matches
                correct = true
                updateGameBoard()
            } else {
                showIncorrectAlert.toggle()
            }
        } else { // selection 2 is word, selection 1 is definition
            if currentGameSet[selection2!.0] == selection1!.0 { // correct matches
                correct = true
                updateGameBoard()
            } else {
                showIncorrectAlert.toggle()
            }
        }
    }
    
    // update view by removing selected game card items when correctly matches and update game states accordingly
    func updateGameBoard() {
        var tempItems: [(String, Int)] = []
        for item in currentGameItems {
            if (item.0 == selection1!.0 || item.0 == selection2!.0){
                continue
            }
            tempItems.append(item)
        }
        currentGameItems = tempItems
        
        resetGameState()
    }
    
    func resetGameState() {
        selection1 = nil
        selection2 = nil
        itemSelected = [false, false, false, false, false, false, false, false, false, false]
        correct = false
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
