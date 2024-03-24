import SwiftUI

struct BookInfoSheetView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    
    var bookshelf: Bookshelf
    var book: Book
    @Binding var showBookInfo: Bool
    
    @State var isEdit: Bool = false
    @State var editedBookTitle: String = ""
    @State var editedAuthor: String = ""
    @State var editedDescription: String = ""
    
    @State var showBookAlreadyExistsAlert: Bool = false
    @State var emptyBookNameAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                userManager.currentTheme.bgColor
                
                VStack {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Book Title:")
                                .font(.subheadline)
                            .foregroundStyle(userManager.currentTheme.fontColor)
                            
                            if isEdit {
                                TextFieldWithoutLabel(placeholder: "title", textValue: $editedBookTitle)
                            } else {
                                Text(book.title)
                                    .font(.title)
                                    .bold()
                                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                            }
                            
                            Text("Book Author:")
                                .font(.subheadline)
                                .foregroundStyle(userManager.currentTheme.fontColor)
                            
                            if isEdit {
                                TextFieldWithoutLabel(placeholder: "author", textValue: $editedAuthor)
                            } else {
                                Text(book.author)
                                    .font(.title2)
                                    .foregroundStyle(userManager.currentTheme.fontColor)
                            }
                            
                            Text("Description:")
                                .font(.subheadline)
                                .foregroundStyle(userManager.currentTheme.fontColor)
                            
                            if isEdit {
                                TextFieldWithoutLabel(placeholder: "description", textValue: $editedDescription)
                            } else {
                                Text(book.description)
                                    .foregroundStyle(userManager.currentTheme.fontColor)
                            }
                            
                        }
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                    }
                    Spacer()
                    if isEdit {
                        HStack {
                            Button1(label: "Done") {
                                Task {
                                    do {
                                        try await booksManager.updateBookInfo(bookshelfID: bookshelf.id, bookID: book.id, title: editedBookTitle, author: editedAuthor, description: editedDescription)
                                    } catch DataErrors.existingNameError {
                                        showBookAlreadyExistsAlert.toggle()
                                    } catch DataErrors.emptyNameError {
                                        emptyBookNameAlert.toggle()
                                    }
                                }
                            }
                        }
                    } else {
                        Button1(label: "Edit") {
                            editedBookTitle = book.title
                            editedAuthor = book.author
                            editedDescription = book.description
                            isEdit.toggle()
                        }
                    }
                }
                .padding()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            showBookInfo.toggle()
                        }
                    }
                    
                    ToolbarItem(placement: .principal) {
                        Text("Book Information")
                            .foregroundStyle(userManager.currentTheme.fontColor)
                    }
                }
                .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
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
    }
}

struct BookInfoSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BookInfoSheetView(bookshelf: Bookshelf(userID: "123", bookshelfName: "English Books"),
                          book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective", author: "Pen Guin", description: "This book follows the adventures of the penguin detective while he solves cases in Antartica."),
                          showBookInfo: .constant(true))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
    }
}
