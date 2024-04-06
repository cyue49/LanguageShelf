import SwiftUI

struct GameResultView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    @Binding var correctAttempts: Double
    @Binding var incorrectAttempts: Double
    
    var body: some View {
        VStack {
            // game complete
            VStack {
                Spacer()
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
                
                Text("Game Complete")
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
            }
            
            // contrats message
            VStack (alignment: .center, spacing: 20){
                Spacer()
                Text("Congratulations!")
                    .bold()
                Text("You have completed the game")
                    .bold()
                Spacer()
            }
            .foregroundColor(userManager.currentTheme.primaryAccentColor)
            .frame(maxWidth: .infinity)
            
            // statistics
            VStack (alignment: .leading){
                Text("Game Round Statistics:")
                    .font(.subheadline)
                    .bold()
                
                VStack (alignment: .leading, spacing: 20){
                    Text("Total number of attempts: \(Int(correctAttempts + incorrectAttempts))")
                    Text("Number of correct attempts: \(Int(correctAttempts))")
                    Text("Number of incorrect attempts: \(Int(incorrectAttempts))")
                    Text("Accuracy: \(calculateAccuracy())%")
                }
                .padding()
                .cornerRadius(30)
                .foregroundColor(userManager.currentTheme.fontColor)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(userManager.currentTheme.buttonColor)
                        .opacity(0.6)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(userManager.currentTheme.primaryAccentColor, lineWidth: 2)
                )
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    func calculateAccuracy() -> String {
        let num = correctAttempts / (correctAttempts + incorrectAttempts)
        let num2 = num * 100
        return String(format: "%.2f", num2)
    }
}

struct GameResultView_Previews: PreviewProvider {
    static var previews: some View {
        GameResultView(correctAttempts: .constant(5), incorrectAttempts: .constant(3))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
            .environmentObject(SentencesManager())
    }
}
