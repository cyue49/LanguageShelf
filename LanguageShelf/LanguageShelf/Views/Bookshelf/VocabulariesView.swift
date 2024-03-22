import SwiftUI

struct VocabulariesView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    
    var body: some View {
        Text("Vocabularies")
    }
}

struct VocabulariesView_Previews: PreviewProvider {
    static var previews: some View {
        VocabulariesView()
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
    }
}
