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
    @State var showBookInfo: Bool = false
    @State var showConfirmDeleteAlert: Bool = false
    
    @State var newBookName: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                NavigationLink(destination: VocabulariesView(book: book)) {
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
                            Button("Show Book Info") {
                                showBookInfo.toggle()
                            }
                            Button("Delete Book") {
                                showConfirmDeleteAlert.toggle()
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
        .sheet(isPresented: $showBookInfo){
            BookInfoSheetView(bookshelf: bookshelf, book: book, showBookInfo: $showBookInfo)
        }
        .alert(isPresented: $showConfirmDeleteAlert) {
            Alert (
                title: Text("Confirm delete"),
                message: Text("Are you sure you want to delete this book? Everything inside this book will also be deleted."),
                primaryButton: .destructive(Text("Delete")) {
                    Task {
                        try await booksManager.removeBook(bookID: book.id)
                    }
                },
                secondaryButton: .cancel()
            )
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
