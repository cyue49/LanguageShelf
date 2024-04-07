import SwiftUI
import SafariServices

struct WordDefinitionsSheetView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    var word: String
    
    @Binding var showSheet: Bool
    @State var wordDefs: [WordDefinitions] = []
    
    @State private var showSafari: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                userManager.currentTheme.bgColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack (alignment: .leading, spacing: 20) {
                        HStack {
                            Image(systemName: "text.book.closed.fill")
                                .foregroundColor(userManager.currentTheme.primaryAccentColor)
                                .font(.system(size: 30))
                            
                            Text(word)
                                .font(.title)
                                .bold()
                                .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                        }
                        
                        if !wordDefs.isEmpty {
                            ForEach(wordDefs) { wordEntry in
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
                                .frame(maxWidth: .infinity, alignment: .center)
                                // Phonetic
                                HStack {
                                    Text("Phonetic:")
                                        .font(.subheadline)
                                        .foregroundStyle(userManager.currentTheme.fontColor)
                                    Text(wordEntry.phonetic)
                                        .foregroundStyle(userManager.currentTheme.fontColor)
                                }
                                
                                Text("Definitions:")
                                    .font(.subheadline)
                                    .foregroundStyle(userManager.currentTheme.fontColor)
                                
                                // all definitions
                                ForEach(wordEntry.meanings){ meaning in
                                    VStack (alignment: .leading, spacing: 20) {
                                        // Part of speech
                                        Text(meaning.partOfSpeech)
                                            .italic()
                                            .bold()
                                            .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                        
                                        // all meanings
                                        ForEach(0..<meaning.definitions.count, id: \.self) { i in
                                            HStack (alignment: .top) {
                                                Text("\(i) -")
                                                    .bold()
                                                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                                Text(meaning.definitions[i].definition)
                                                    .foregroundStyle(userManager.currentTheme.fontColor)
                                            }
                                        }
                                    }
                                    .padding()
                                    .frame( maxWidth: .infinity, alignment: .leading)
                                    .background(userManager.currentTheme.buttonColor)
                                    .cornerRadius(20)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                                    )
                                }
                            }
                        } else {
                            VStack (alignment: .center, spacing: 20) {
                                Text("Online dictionary not available.")
                                    .foregroundStyle(userManager.currentTheme.fontColor)
                                Button("Search on Safari"){
                                    showSafari.toggle()
                                }
                                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
            }
            .sheet(isPresented: $showSafari){
                SFSafariViewWrapper(url: URL(string: "https://www.google.com/search?q=\(word)")!)
                    .ignoresSafeArea()
                    .onDisappear(){
                        showSheet.toggle()
                    }
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

struct SFSafariViewWrapper: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
        return
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
