import SwiftUI

struct BookshelfCardView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    
    var bookshelf: Bookshelf
    @State var showEditNameAlert: Bool = false
    @State var showBookshelfAlreadyExistsAlert: Bool = false
    @State var emptyBookshelfNameAlert: Bool = false
    
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
                            Task {
                                try await bookshelvesManager.removeBookshelf(bookshelfID: bookshelf.id)
                            }
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
    }
}

struct BookshelfCardView_Previews: PreviewProvider {
    static var previews: some View {
        BookshelfCardView(bookshelf: Bookshelf(userID: "123", bookshelfName: "English Books"))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
    }
}
