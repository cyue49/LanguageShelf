import SwiftUI
import Firebase

struct UserProfileView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                userManager.currentTheme.bgColor
                
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
                        .foregroundStyle(userManager.currentTheme.fontColor)
                }
                
                if userManager.userSession != nil {
                    ToolbarItem(placement: .topBarTrailing){
                        Button("Sign Out") {
                            userManager.signOut()
                        }
                        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                    }
                }
            }
            .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .environmentObject(UserAccountsManager())
    }
}
