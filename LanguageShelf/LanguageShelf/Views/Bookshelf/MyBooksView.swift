import SwiftUI

struct MyBooksView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    
    var bookshelf: Bookshelf
    
    @State var newBookName: String = ""
    @State var showAddBookAlert: Bool = false
    
    var body: some View {
        NavigationStack {
                ZStack {
                    userManager.currentTheme.bgColor
                    
                    ScrollView {
                        let columns = [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]
                        
                        LazyVGrid(columns: columns, content: {
                            BookCardView(bookName: "The Penguin Detective")
                            BookCardView(bookName: "The Penguin Detective")
                            BookCardView(bookName: "The Penguin Detective")
                            BookCardView(bookName: "The Penguin Detective")
                            BookCardView(bookName: "The Penguin Detective")
                            BookCardView(bookName: "The Penguin Detective")
                            BookCardView(bookName: "The Penguin Detective")
                        })
                        .padding()
                    }
                }
            .toolbar {
                ToolbarItem(placement: .principal){
                    Text(bookshelf.bookshelfName)
                        .foregroundStyle(userManager.currentTheme.fontColor)
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        newBookName = ""
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
            .alert("Enter the new book's title:", isPresented: $showAddBookAlert){
                TextField("Book", text: $newBookName)
                Button("Confirm") {
                    // TODO:
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

struct MyBooks_Previews: PreviewProvider {
    static var previews: some View {
        MyBooksView(bookshelf: Bookshelf(userID: "123", bookshelfName: "English Books"))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
    }
}
