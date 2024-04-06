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
        VStack{
            Text("Total number of attempts: \(Int(correctAttempts + incorrectAttempts))")
            Text("Number of correct attempts: \(Int(correctAttempts))")
            Text("Number of incorrect attempts: \(Int(incorrectAttempts))%")
            Text("Accuracy: \(calculateAccuracy())")
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
