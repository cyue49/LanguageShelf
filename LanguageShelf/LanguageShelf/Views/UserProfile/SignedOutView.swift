import SwiftUI
import Firebase

struct SignedOutView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    
    @State private var hasAccount: Bool = true
    @State private var isLoggedIn: Bool = false
    
    var body: some View {
        if isLoggedIn {
            SignedInView()
        } else {
            if hasAccount {
                signIn
            } else {
                signUp
            }
        }
    }
    
    var signIn: some View {
        ZStack {
            Color("BackgroundColor")
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(Color("ToolBarColor"))
                .frame(width:350, height: 550)
            
            VStack (alignment: .center, spacing: 30) {
                Text("Sign In")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(Color("FontColor"))
                    .padding(.bottom)
                
                TextFieldWithLabel(label: "Enter your email: ", placeholder: "", textValue: $email)
                TextFieldWithLabel(label: "Enter your password: ", placeholder: "", textValue: $password, isSecureField: true)
                
                Button1(label: "Sign In", clicked: {
                    login()
                })
                .padding(.top)
                
                Button {
                    hasAccount.toggle()
                } label: {
                    Text("Don't have an account? Sign up here!")
                        .underline()
                        .foregroundStyle(Color("PrimaryAccentColor"))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(50)
            .onAppear() {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        isLoggedIn = true 
                    }
                }
            }
        }
    }
    
    var signUp: some View {
        ZStack {
            Color("BackgroundColor")
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(Color("ToolBarColor"))
                .frame(width:350, height: 600)
            
            VStack (alignment: .center, spacing: 30) {
                Text("Sign Up")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(Color("FontColor"))
                    .padding(.bottom)
                
                TextFieldWithLabel(label: "Enter your email: ", placeholder: "", textValue: $email)
                TextFieldWithLabel(label: "Enter your password: ", placeholder: "", textValue: $password, isSecureField: true)
                TextFieldWithLabel(label: "Enter your username: ", placeholder: "", textValue: $username)
                
                Button1(label: "Sign Up", clicked: {
                    register()
                })
                .padding(.top)
                .onAppear() {
                    Auth.auth().addStateDidChangeListener { auth, user in
                        if user != nil {
                            isLoggedIn = true
                        }
                    }
                }
                
                Button {
                    hasAccount.toggle()
                } label: {
                    Text("Already have an account? Sign in here!")
                        .underline()
                        .foregroundStyle(Color("PrimaryAccentColor"))
                        .multilineTextAlignment(.center)
                }
            }
            .padding(50)
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            }
        }
        
        userManager.addUser(email: email, username: username)
    }
}

struct SignedOutView_Previews: PreviewProvider {
    static var previews: some View {
        SignedOutView()
            .environmentObject(UserAccountsManager())
    }
}
