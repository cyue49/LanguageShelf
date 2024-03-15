import SwiftUI

struct MyBookshelvesView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("My Bookshelves")
            }
            .navigationTitle("My Bookshelves")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Text("Logo")
                }
                ToolbarItem(placement: .topBarTrailing){
                    Image(systemName: "plus")                }
            }
            .toolbarBackground(Color("ToolBarColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct MyBookshelves_Previews: PreviewProvider {
    static var previews: some View {
        MyBookshelvesView()
    }
}
