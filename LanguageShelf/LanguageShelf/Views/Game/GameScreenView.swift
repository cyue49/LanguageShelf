import SwiftUI

struct GameScreenView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Game Screen")
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Text("Logo")
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Game Screen")
                        .foregroundStyle(themeManager.currentTheme.fontColor)
                }
            }
            .toolbarBackground(themeManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameScreenView()
            .environmentObject(ThemeManager())
    }
}
