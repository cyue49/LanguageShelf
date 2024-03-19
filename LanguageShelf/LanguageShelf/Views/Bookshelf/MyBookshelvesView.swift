import SwiftUI

struct MyBookshelvesView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("My Bookshelves")
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Text("Logo")
                }
                
                ToolbarItem(placement: .principal) {
                    Text("My Bookshelves")
                        .foregroundStyle(themeManager.currentTheme.fontColor)
                }
                
                ToolbarItem(placement: .topBarTrailing){
                    Image(systemName: "plus")                }
            }
            .toolbarBackground(themeManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct MyBookshelves_Previews: PreviewProvider {
    static var previews: some View {
        MyBookshelvesView()
            .environmentObject(ThemeManager())
    }
}
