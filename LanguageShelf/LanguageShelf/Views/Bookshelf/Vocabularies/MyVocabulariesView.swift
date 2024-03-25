import SwiftUI

struct VocabulariesView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    
    var body: some View {
        Text("Vocabularies")
    }
}

struct VocabulariesView_Previews: PreviewProvider {
    static var previews: some View {
        VocabulariesView()
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
    }
}
