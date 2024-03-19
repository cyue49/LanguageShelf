import SwiftUI
import Firebase

struct UserProfileView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                themeManager.currentTheme.bgColor
                
                VStack {
                    if userManager.userSession != nil {
                        SignedInView()
                    } else {
                        SignedOutView()
                    }
                }
                .padding(20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Text("Logo")
                }
                
                ToolbarItem(placement: .principal) {
                    Text("User Profile")
                        .foregroundStyle(themeManager.currentTheme.fontColor)
                }
                
                if userManager.userSession != nil {
                    ToolbarItem(placement: .topBarTrailing){
                        Button("Sign Out") {
                            userManager.signOut()
                        }
                        .foregroundStyle(themeManager.currentTheme.primaryAccentColor)
                    }
                }
            }
            .toolbarBackground(themeManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .environmentObject(UserAccountsManager())
            .environmentObject(ThemeManager())
    }
}
