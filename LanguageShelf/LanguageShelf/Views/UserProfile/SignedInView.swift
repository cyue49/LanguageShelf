import SwiftUI
import Firebase

struct SignedInView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var body: some View {
        if let user = userManager.currentUser {
            VStack {
                Text("Signed in user: \(user.username)")
                Button1(label: "Sign Out", clicked: {
                    userManager.signOut()
                })
            }
        }
    }
}

struct SignedInView_Previews: PreviewProvider {
    static var previews: some View {
        SignedInView()
            .environmentObject(UserAccountsManager())
    }
}
