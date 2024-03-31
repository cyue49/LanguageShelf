import SwiftUI

struct BookshelfCardView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    var bookshelf: Bookshelf
    @State var showEditNameAlert: Bool = false
    @State var showBookshelfAlreadyExistsAlert: Bool = false
    @State var emptyBookshelfNameAlert: Bool = false
    @State var showConfirmDeleteAlert: Bool = false
    
    @State var newBookshelfName: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                NavigationLink(destination: MyBooksView(bookshelf: bookshelf)) { 
                    VStack {
                        VStack {
                            Spacer()
                            HStack {
                                Image(systemName: "books.vertical.fill")
                                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                    .font(.system(size: 60))
                                    .offset(x: -10, y: 10)
                                
                                VStack {
                                    Spacer()
                                    Text(bookshelf.bookshelfName)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .foregroundStyle(userManager.currentTheme.fontColor)
                                        .lineLimit(2)
                                }
                            }
                            .padding(.leading, 25)
                            
                            Rectangle()
                                .frame(maxWidth : .infinity, maxHeight: 20)
                                .cornerRadius(30)
                                .foregroundStyle(userManager.currentTheme.toolbarColor)
                        }
                        .padding()
                    }
                    .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 150)
                    .backgroundStyle(userManager.currentTheme.bgColor2)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                    )
                }
                
                VStack {
                    Menu {
                        Button("Rename") {
                            newBookshelfName = bookshelf.bookshelfName
                            showEditNameAlert.toggle()
                        }
                        Button("Delete") {
                            showConfirmDeleteAlert.toggle()
                        }
                    } label: {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                            .font(.system(size: 28))
                    }
                    Spacer()
                }
                .padding(10)
                .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 150, alignment: .trailing)
            }
        }
        .alert("Enter the bookshelf's name:", isPresented: $showEditNameAlert){
            TextField("Bookshelf", text: $newBookshelfName)
            Button("Confirm") {
                Task {
                    do {
                        try await bookshelvesManager.renameBookshelf(bookshelfID: bookshelf.id, newName: newBookshelfName)
                    } catch DataErrors.existingNameError {
                        showBookshelfAlreadyExistsAlert.toggle()
                    } catch DataErrors.emptyNameError {
                        emptyBookshelfNameAlert.toggle()
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("A bookshelf of this name already exists.", isPresented: $showBookshelfAlreadyExistsAlert){
            Button("Ok", role: .cancel) {
                showBookshelfAlreadyExistsAlert = false
            }
        }
        .alert("You must enter a name for your bookshelf.", isPresented: $emptyBookshelfNameAlert){
            Button("Ok", role: .cancel) {
                emptyBookshelfNameAlert = false
            }
        }
        .alert(isPresented: $showConfirmDeleteAlert) {
            Alert (
                title: Text("Confirm delete"),
                message: Text("Are you sure you want to delete this bookshelf? Everything inside this bookshelf will also be deleted."),
                primaryButton: .destructive(Text("Delete")) {
                    deleteBookshelf(bookshelfID: bookshelf.id)
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    func deleteBookshelf(bookshelfID: String) {
        Task {
            // for all books in this bookshelf
            let allBooksInThisBookshelf = try await booksManager.fetchAllBooksInThisBookshelf(bookshelfID: bookshelfID)
            
            for aBook in allBooksInThisBookshelf {
                // remove all vocabs in this book
                let allVocabsInThisBook = try await vocabsManager.fetchAllVocabInBook(bookID: aBook.id)
                for vocab in allVocabsInThisBook {
                    try await vocabsManager.removeVocabulary(vocabularyID: vocab.id)
                }
                
                // remove all sentences in this book
                let allSentencesInThisBook = try await sentencesManager.fetchAllSentencesInBook(bookID: aBook.id)
                for sentence in allSentencesInThisBook {
                    try await sentencesManager.removeSentence(sentenceID: sentence.id)
                }
                
                // delete this book
                try await booksManager.removeBook(bookID: aBook.id)
            }
            
            // delete this bookshelf
            try await bookshelvesManager.removeBookshelf(bookshelfID: bookshelf.id)
        }
    }
}

struct BookshelfCardView_Previews: PreviewProvider {
    static var previews: some View {
        BookshelfCardView(bookshelf: Bookshelf(userID: "123", bookshelfName: "English Books"))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
            .environmentObject(SentencesManager())
    }
}
