import SwiftUI
import Firebase

struct UserProfileView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("BackgroundColor")
                
                VStack {
                    if userManager.userSession != nil {
                        SignedInView()
                    } else {
                        SignedOutView()
                    }
                }
                .padding(20)
            }
            .navigationTitle("User Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Text("Logo")
                }
                if userManager.userSession != nil {
                    ToolbarItem(placement: .topBarTrailing){
                        Button("Sign Out") {
                            userManager.signOut()
                        }
                        .foregroundStyle(Color("PrimaryAccentColor"))
                    }
                }
            }
            .toolbarBackground(Color("ToolBarColor"), for: .navigationBar)
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
