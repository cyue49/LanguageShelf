import SwiftUI
import Firebase

struct SignedInView: View {
    @State private var isLoggedIn: Bool = true
    
    var body: some View {
        if isLoggedIn {
            userProfile
        } else {
            SignedOutView()
        }
    }
    
    var userProfile: some View {
        ZStack {
            Color("BackgroundColor")
            
            
            VStack {
                Text("Signed in user")
                Button1(label: "Sign Out", clicked: {
                    logout()
                })
            }
            .onAppear() {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user == nil {
                        isLoggedIn = false
                    }
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("error login out")
        }
    }
}

struct SignedInView_Previews: PreviewProvider {
    static var previews: some View {
        SignedInView()
    }
}
