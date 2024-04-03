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
                        Text(wordDefs[0].entry[0].meanings[0].definitions[0].definition)
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
        let (data, _) = try await URLSession.shared.data(from: url)
        print("here")
        let result = try JSONDecoder().decode(WordDefinitions.self, from: data)
        print("here2")
        wordDefs.append(result)
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
