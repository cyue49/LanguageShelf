import SwiftUI

struct GameStartScreenView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [userManager.currentTheme.bgColor,
                                                           userManager.currentTheme.primaryAccentColor]),
                               startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                
                if userManager.userSession != nil {
                    VStack {
                        Text("Vocab-Definition Matching Game")
                            .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                            .bold()
                            .font(.system(size: 30))
                        
                        HStack {
                            Rectangle()
                                .frame(width: 150, height: 3)
                                .foregroundColor(userManager.currentTheme.primaryAccentColor)
                            Image(systemName: "leaf.fill")
                                .foregroundColor(userManager.currentTheme.primaryAccentColor)
                                .font(.system(size: 20))
                            Rectangle()
                                .frame(width: 150, height: 3)
                                .foregroundColor(userManager.currentTheme.primaryAccentColor)
                        }
                        
                        VStack {
                            ScrollView {
                                VStack (alignment: .leading, spacing: 12) {
                                    Text("How to play")
                                        .font(.title2)
                                        .bold()
                                    
                                    Text("Upon clicking on Start Game, 10 random cards will be shown on the screen. 5 of them will be vocabulary cards and the other 5 will be definition cards. Your goal is to match all the vocabularies and definitions!")
                                    Text("Click on two matching cards to make them disapear. The game ends when all cards are cleared!")
                                    Text("Anytime during the game, you can click on the refresh button at the top right of the screen to get another set of cards and restart the game.")
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                .background(
                                    RoundedRectangle(cornerRadius: 30)
                                        .foregroundStyle(userManager.currentTheme.bgColor)
                                        .opacity(0.6)
                                )
                                .cornerRadius(30)
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(userManager.currentTheme.bgColor, lineWidth: 2)
                            )
                        }
                        .padding(.vertical)
                        
                        NavigationLink(destination: GameScreenView()) {
                            ZStack {
                                Rectangle()
                                    .frame(maxWidth: .infinity, maxHeight: 70)
                                    .cornerRadius(30)
                                    .foregroundStyle(
                                        userManager.currentTheme.primaryAccentColor
                                    )
                                
                                Text("Start Game")
                                    .foregroundStyle(userManager.currentTheme.bgColor)
                                    .bold()
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(userManager.currentTheme.bgColor, lineWidth: 2)
                            )
                        }
                    }
                    .padding(.vertical, 20)
                    .padding(.horizontal, 10)
                } else { // display log in message
                    Text("Please sign in to play a game")
                        .foregroundStyle(userManager.currentTheme.fontColor)
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
}

struct GameStartScreenView_Previews: PreviewProvider {
    static var previews: some View {
        GameStartScreenView()
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
            .environmentObject(SentencesManager())
    }
}
