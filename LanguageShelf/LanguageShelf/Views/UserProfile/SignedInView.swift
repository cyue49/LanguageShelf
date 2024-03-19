import SwiftUI
import Firebase

struct SignedInView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        if let user = userManager.currentUser {
            VStack (alignment: .center, spacing: 25) {
                Circle()
                    .fill(themeManager.currentTheme.buttonColor)
                    .stroke(themeManager.currentTheme.secondaryColor, lineWidth: 2)
                    .frame(width: 150, height: 150)
                    .padding(.top)
                
                Text(user.username)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: 20)
                    .padding(.bottom)
                
                ChooseColorThemeView()
                
                Spacer()
            }
            .padding()
        }
    }
}

struct SignedInView_Previews: PreviewProvider {
    static var previews: some View {
        SignedInView()
            .environmentObject(UserAccountsManager())
            .environmentObject(ThemeManager())
    }
}
