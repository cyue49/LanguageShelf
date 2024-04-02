import SwiftUI

struct MyBooksView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    
    var bookshelf: Bookshelf
    
    @State var newBookName: String = ""
    @State var newAuthorName: String = ""
    
    @State var showAddBookAlert: Bool = false
    @State var showBookAlreadyExistsAlert: Bool = false
    @State var emptyBookNameAlert: Bool = false
    
    @State var showLoadingSpinner: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                userManager.currentTheme.bgColor
                
                if booksManager.myBooks[bookshelf.id] == nil { // No book in this bookshelf
                    Text("You don't have any book in this bookshelf.")
                        .foregroundStyle(userManager.currentTheme.fontColor)
                } else {
                    ScrollView {
                        let columns = [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]
                        
                        LazyVGrid(columns: columns, content: {
                            ForEach(booksManager.myBooks[bookshelf.id]!) { book in
                                BookCardView(bookshelf: bookshelf, book: book)
                            }
                        })
                        .padding()
                    }
                }
                LoadingSpinnerView(showLoadingSpinner: $showLoadingSpinner)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal){
                    Text(bookshelf.bookshelfName)
                        .foregroundStyle(userManager.currentTheme.fontColor)
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        newBookName = ""
                        newAuthorName = ""
                        showAddBookAlert.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                            .bold()
                    })
                }
            }
            .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .alert("Enter the new book's information:", isPresented: $showAddBookAlert){
                TextField("Book", text: $newBookName)
                TextField("Author (optional)", text: $newAuthorName)
                Button("Confirm") {
                    Task {
                        do {
                            try await booksManager.addNewBook(bookshelfID: bookshelf.id, bookName: newBookName, author: newAuthorName)
                        } catch DataErrors.existingNameError {
                            showBookAlreadyExistsAlert.toggle()
                        } catch DataErrors.emptyNameError {
                            emptyBookNameAlert.toggle()
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            .alert("A book of this name already exists.", isPresented: $showBookAlreadyExistsAlert){
                Button("Ok", role: .cancel) {
                    showBookAlreadyExistsAlert = false
                }
            }
            .alert("You must enter a name for your book.", isPresented: $emptyBookNameAlert){
                Button("Ok", role: .cancel) {
                    emptyBookNameAlert = false
                }
            }
            .onAppear(){
                if booksManager.myBooks[bookshelf.id] != nil{
                    showLoadingSpinner = true
                }
            }
        }
    }
}

struct MyBooks_Previews: PreviewProvider {
    static var previews: some View {
        MyBooksView(bookshelf: Bookshelf(userID: "123", bookshelfName: "English Books"))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
    }
}
