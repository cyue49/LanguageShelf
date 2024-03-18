import SwiftUI
import Firebase

struct SignedOutView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    
    @State private var hasAccount: Bool = true
    
    var body: some View {
        if hasAccount {
            signIn
        } else {
            signUp
        }
    }
    
    var signIn: some View {
        GroupBox {
            VStack (alignment: .center, spacing: 25) {
                Text("Sign In")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(Color("FontColor"))
                    .padding(.bottom)
                
                TextFieldWithLabel(label: "Enter your email: ", placeholder: "", textValue: $email)
                TextFieldWithLabel(label: "Enter your password: ", placeholder: "", textValue: $password, isSecureField: true)
                
                Button1(label: "Sign In", clicked: {
                    Task {
                        try await userManager.signIn(
                            email: email,
                            password: password)
                    }
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
            .padding()
        }
        .backgroundStyle(Color("ToolBarColor"))
        .cornerRadius(30)
    }
    
    var signUp: some View {
        GroupBox {
            VStack (alignment: .center, spacing: 25) {
                Text("Sign Up")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(Color("FontColor"))
                    .padding(.bottom)
                
                TextFieldWithLabel(label: "Enter your email: ", placeholder: "", textValue: $email)
                TextFieldWithLabel(label: "Enter your password: ", placeholder: "", textValue: $password, isSecureField: true)
                TextFieldWithLabel(label: "Enter your username: ", placeholder: "", textValue: $username)
                
                Button1(label: "Sign Up", clicked: {
                    Task {
                        try await userManager.register(
                            email: email,
                            password: password,
                            username: username)
                    }
                })
                .padding(.top)
                
                Button {
                    hasAccount.toggle()
                } label: {
                    Text("Already have an account? Sign in here!")
                        .underline()
                        .foregroundStyle(Color("PrimaryAccentColor"))
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
        }
        .backgroundStyle(Color("ToolBarColor"))
        .cornerRadius(30)
    }
}

struct SignedOutView_Previews: PreviewProvider {
    static var previews: some View {
        SignedOutView()
            .environmentObject(UserAccountsManager())
    }
}
