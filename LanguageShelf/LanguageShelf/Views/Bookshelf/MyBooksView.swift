import SwiftUI

struct MyBooksView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    
    var bookshelfName: String
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    userManager.currentTheme.bgColor
                    
                    ScrollView {
                        let columns = [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ]
                        
                        LazyVGrid(columns: columns, content: {
                            BookCardView(bookshelfName: bookshelfName, bookName: "The Penguin Detective")
                            BookCardView(bookshelfName: bookshelfName, bookName: "The Penguin Detective")
                            BookCardView(bookshelfName: bookshelfName, bookName: "The Penguin Detective")
                            BookCardView(bookshelfName: bookshelfName, bookName: "The Penguin Detective")
                            BookCardView(bookshelfName: bookshelfName, bookName: "The Penguin Detective")
                            BookCardView(bookshelfName: bookshelfName, bookName: "The Penguin Detective")
                            BookCardView(bookshelfName: bookshelfName, bookName: "The Penguin Detective")
                        })
                        .padding()
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal){
                    Text(bookshelfName)
                        .foregroundStyle(userManager.currentTheme.fontColor)
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Button(action: {
                        //TODO:
                    }, label: {
                        Image(systemName: "plus")
                            .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                            .bold()
                    })
                }
            }
            .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct MyBooks_Previews: PreviewProvider {
    static var previews: some View {
        MyBooksView(bookshelfName: "English Books")
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
    }
}
