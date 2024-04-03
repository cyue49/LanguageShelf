import SwiftUI

struct WordDefinitionsSheetView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    var word: String
    
    @Binding var showSheet: Bool
    @State var wordDefs: [WordDefinitions] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                userManager.currentTheme.bgColor
                    .ignoresSafeArea()
                
                VStack {
                    Text(word)
                    if !wordDefs.isEmpty {
                        Text(wordDefs[0].phonetic)
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        showSheet.toggle()
                    }
                }
            }
            .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .onAppear(){
                Task {
                    try await fetchData()
                }
            }
        }
    }
    
    func fetchData() async throws{
        guard let url = URL(string: "https://api.dictionaryapi.dev/api/v2/entries/en/\(word)") else { return }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return } // code 200 means everything's ok
        let result = try JSONDecoder().decode([WordDefinitions].self, from: data)
        wordDefs = result
    }
}

struct WordDefinitionsSheetView_Previews: PreviewProvider {
    static var previews: some View {
        WordDefinitionsSheetView(word: "Test", showSheet: .constant(true))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
            .environmentObject(SentencesManager())
    }
}
