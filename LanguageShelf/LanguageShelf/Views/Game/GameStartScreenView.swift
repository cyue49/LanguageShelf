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
                userManager.currentTheme.bgColor
                .ignoresSafeArea()
                
                if userManager.userSession != nil {
                    if userManager.verifiedUser {
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
                                    .foregroundStyle(userManager.currentTheme.fontColor)
                                    .background(
                                        RoundedRectangle(cornerRadius: 30)
                                            .foregroundStyle(userManager.currentTheme.buttonColor)
                                    )
                                    .cornerRadius(30)
                                }
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(userManager.currentTheme.primaryAccentColor, lineWidth: 2.5)
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
                            }
                        }
                        .padding(.vertical, 20)
                        .padding(.horizontal, 10)
                    } else {
                        VStack (spacing: 20){
                            Text("Please verify your email to user this functionality.")
                                .foregroundStyle(userManager.currentTheme.fontColor)
                            Text("Click on the button below after you have verified your email to continue.")
                                .foregroundStyle(userManager.currentTheme.fontColor)
                            Button("I have verified my email."){
                                Task {
                                    try await userManager.reloadUser()
                                }
                            }
                        }
                    }
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
