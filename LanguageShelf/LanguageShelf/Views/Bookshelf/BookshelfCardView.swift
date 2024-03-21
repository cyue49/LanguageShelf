import SwiftUI

struct BookshelfCardView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    
    var name: String
    @State var showEditNameAlert: Bool = false
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                HStack {
                    Rectangle()
                        .frame(maxWidth: 19, maxHeight: .infinity)
                        .cornerRadius(5)
                        .foregroundColor(userManager.currentTheme.primaryAccentColor)
                    
                    VStack {
                        Spacer()
                        Rectangle()
                            .frame(maxWidth: 17, maxHeight: 55)
                            .cornerRadius(5)
                            .foregroundColor(userManager.currentTheme.primaryAccentColor)
                            .rotationEffect(.degrees(-20))
                    }
                    
                    VStack {
                        HStack {
                            Spacer()
                            Menu {
                                Button("Rename") {
                                    showEditNameAlert.toggle()
                                }
                                Button("Delete") {
                                    Task {
                                        try await bookshelvesManager.removeBookshelf(name: name)
                                    }
                                }
                            } label: {
                                Image(systemName: "square.and.pencil.circle.fill")
                                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                    .font(.system(size: 28))
                            }
                        }
                        Spacer()
                        Text(name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 15)
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
        .alert("Enter the bookshelf's name:", isPresented: $showEditNameAlert){
            TextField("Bookshelf", text: .constant(name))
            Button("Confirm") {
                // perform database update operations
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

struct BookshelfCardView_Previews: PreviewProvider {
    static var previews: some View {
        BookshelfCardView(name: "Bookshelf name")
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
    }
}
