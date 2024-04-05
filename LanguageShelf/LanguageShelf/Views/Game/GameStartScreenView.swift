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
                        Spacer()
                        
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
                        .padding()
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
