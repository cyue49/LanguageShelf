import SwiftUI

struct BookInfoSheetView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    
    var book: Book
    @Binding var showBookInfo: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Book Title: \(book.title)")
                    .foregroundStyle(userManager.currentTheme.fontColor)
                Text("Author: \(book.author)")
                    .foregroundStyle(userManager.currentTheme.fontColor)
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        showBookInfo.toggle()
                    }
                }
            }
        }
    }
}

struct BookInfoSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BookInfoSheetView(book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"), showBookInfo: .constant(true))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
    }
}
