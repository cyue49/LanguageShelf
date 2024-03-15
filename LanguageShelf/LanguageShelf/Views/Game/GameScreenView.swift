import SwiftUI

struct GameScreenView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Game Screen")
            }
            .navigationTitle("Game Screen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Text("Logo")
                }
            }
            .toolbarBackground(Color("ToolBarColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameScreenView()
    }
}
