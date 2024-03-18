import SwiftUI
import Firebase

struct SignedInView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
            
            
            VStack {
                Text("Signed in user")
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
    }
}
