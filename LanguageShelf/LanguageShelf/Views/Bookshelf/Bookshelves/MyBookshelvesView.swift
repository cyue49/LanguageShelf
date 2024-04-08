import SwiftUI
import Firebase

struct MyBookshelvesView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    
    @State var showAddBookshelfAlert: Bool = false
    @State var showBookshelfAlreadyExistsAlert: Bool = false
    @State var emptyBookshelfNameAlert: Bool = false
    
    @State var newShelfName: String = ""
    
    @State var showLoadingSpinner: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                userManager.currentTheme.bgColor
                
                if userManager.userSession != nil { 
                    if userManager.userSession!.isEmailVerified {
                        if bookshelvesManager.myBookshelves.count == 0 { // No bookshelf yet
                            Text("You don't have any bookshelf.")
                                .foregroundStyle(userManager.currentTheme.fontColor)
                        } else {
                            ScrollView{
                                VStack(spacing: 15) {
                                    ForEach(bookshelvesManager.myBookshelves) { bookshelf in
                                        BookshelfCardView(bookshelf: bookshelf, showLoadingSpinner: $showLoadingSpinner)
                                    }
                                    Spacer()
                                }
                                .padding()
                            }
                        }
                    } else {
                        VStack (spacing: 20){
                            Text("Please verify your email to user this functionality.")
                                .foregroundStyle(userManager.currentTheme.fontColor)
                            Text("Click on the button below after you have verified your email to continue.")
                                .foregroundStyle(userManager.currentTheme.fontColor)
                            Button("I have verified my email."){
                                userManager.userSession!.reload()
                            }
                        }
                    }
                } else { // display log in message
                    Text("Please sign in to view your bookshelves")
                        .foregroundStyle(userManager.currentTheme.fontColor)
                }
                LoadingSpinnerView(showLoadingSpinner: $showLoadingSpinner, loadTime: 1.5)
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
                        
                        if userManager.userSession != nil && userManager.userSession!.isEmailVerified {
                            VStack {
                                Button(action: {
                                    newShelfName = ""
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
                    Task {
                        do {
                            showLoadingSpinner = true
                            try await bookshelvesManager.addNewBookshelf(name: newShelfName)
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
            .onChange(of: newShelfName) {
                if newShelfName.count > 30 {
                    newShelfName = String(newShelfName.prefix(30))
                }
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
