import SwiftUI
import Firebase

struct MyBookshelvesView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    
    @State var showAddBookshelfAlert: Bool = false
    @State var newShelfName: String = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                userManager.currentTheme.bgColor
                
                if let bookshelves = bookshelvesManager.myBookshelves {
                    ScrollView{
                        VStack(spacing: 15) {
                            ForEach(bookshelves, id: \.self) { bookshelf in
                                BookshelfCardView(name: bookshelf)
                            }
                            Spacer()
                        }
                        .padding()
                    }
                } else {
                    Text("Please sign in to view your bookshelves")
                        .foregroundStyle(userManager.currentTheme.fontColor)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    ZStack {
                        VStack {
                            switch userManager.currentTheme.name {
                            case "default":
                                Image(.logo1024Blue)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case "light":
                                Image(.logo1024Light)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case "dark":
                                Image(.logo1024Dark)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            case "green":
                                Image(.logo1024Green)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            default:
                                Text("LanguageShelf")
                                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack {
                            Text("My Bookshelves")
                                .foregroundStyle(userManager.currentTheme.fontColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        
                        if userManager.userSession != nil {
                            VStack {
                                Button(action: {
                                    showAddBookshelfAlert.toggle()
                                }, label: {
                                    Image(systemName: "plus")
                                        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                        .bold()
                                })
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
                
            }
            .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .alert("Enter the new bookshelf's name:", isPresented: $showAddBookshelfAlert){
                TextField("Bookshelf", text: $newShelfName)
                Button("Confirm") {
                    //TODO: perform database add operations
                    print("adding bookshelf")
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
}

struct MyBookshelves_Previews: PreviewProvider {
    static var previews: some View {
        MyBookshelvesView()
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
    }
}
