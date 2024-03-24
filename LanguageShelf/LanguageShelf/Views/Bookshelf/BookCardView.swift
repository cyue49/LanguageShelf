import SwiftUI

struct BookCardView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    
    var book: Book
    
    @State var showEditNameAlert: Bool = false
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
                                // TODO:
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
                .lineLimit(1)
        }
        .alert("Enter the book title:", isPresented: $showEditNameAlert){
            TextField("Book", text: $newBookName)
            Button("Confirm") {
                // TODO:
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

struct BookCardView_Previews: PreviewProvider {
    static var previews: some View {
        BookCardView(book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
    }
}
