import SwiftUI

struct BookCardView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    
    var bookshelf: Bookshelf
    var book: Book
    
    @State var showEditNameAlert: Bool = false
    @State var showBookAlreadyExistsAlert: Bool = false
    @State var emptyBookNameAlert: Bool = false
    
    @State var newBookName: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                NavigationLink(destination: VocabulariesView()) {
                    VStack {
                        Image(systemName: "book.fill")
                            .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                        .font(.system(size: 28))
                    }
                    .padding(6)
                    .frame(maxWidth: 100, minHeight: 120, maxHeight: 120)
                    .backgroundStyle(userManager.currentTheme.bgColor2)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                )
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Menu {
                            Button("Rename") {
                                newBookName = book.title
                                showEditNameAlert.toggle()
                            }
                            Button("Delete") {
                                Task {
                                    try await booksManager.removeBook(bookID: book.id)
                                }
                            }
                        } label: {
                            Image(systemName: "square.and.pencil.circle.fill")
                                .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                .font(.system(size: 28))
                        }
                    }
                    Spacer()
                }
                .padding(6)
                .frame(maxWidth: 100, minHeight: 120, maxHeight: 120)
            }
            
            Text(book.title)
                .foregroundStyle(userManager.currentTheme.fontColor)
                .frame(maxWidth: 100)
                .lineLimit(2)
        }
        .alert("Enter the book title:", isPresented: $showEditNameAlert){
            TextField("Book", text: $newBookName)
            Button("Confirm") {
                Task {
                    do {
                        try await booksManager.renameBook(bookshelfID: bookshelf.id, bookID: book.id, newName: newBookName)
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
    }
}

struct BookCardView_Previews: PreviewProvider {
    static var previews: some View {
        BookCardView(bookshelf: Bookshelf(userID: "123", bookshelfName: "English Books"),
                     book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
    }
}
