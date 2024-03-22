import SwiftUI

struct BookCardView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    
    var bookshelfName: String
    var bookName: String 
    
    var body: some View {
        VStack {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Menu {
                            Button("Rename") {
                                // TODO:
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
                .backgroundStyle(userManager.currentTheme.bgColor2)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                )
                Image(systemName: "book.fill")
                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                    .font(.system(size: 28))
            }
            Text("The Penguin Detective")
                .foregroundStyle(userManager.currentTheme.fontColor)
                .frame(maxWidth: 100)
                .lineLimit(1)
        }
    }
}

struct BookCardView_Previews: PreviewProvider {
    static var previews: some View {
        BookCardView(bookshelfName: "English Books", bookName: "The Penguin Detective")
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
    }
}
