import SwiftUI
import Firebase

struct SignedOutView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var username: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var hasAccount: Bool = true
    
    @State private var showLoginAlert: Bool = false
    @State private var showSignupAlert: Bool = false
    
    private var validEmail: Bool {
        return !email.isEmpty
        && email.contains("@")
        && email.contains(".")
    }
    
    private var validPassword: Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[A-Z]+.*)(?=.*[0-9]+.*)(?=.*[!&^%$#@()/_*+-]+.*).{8,}$")
        
        return !password.isEmpty
        && password.count>=8
        && passwordRegex.evaluate(with: password)
    }
    
    private var validConfirmPassword: Bool {
        return !confirmPassword.isEmpty
        && confirmPassword == password
    }
    
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
                    .foregroundStyle(userManager.currentTheme.fontColor)
                    .padding(.bottom)
                
                ScrollView {
                    TextFieldWithLabel(label: "Enter your email", placeholder: "", textValue: $email)
                    SecureTextFieldWithEye(label: "Enter your password", placeholder: "", textValue: $password)
                }
                
                Button1(label: "Sign In", clicked: {
                    Task {
                        showLoginAlert = try await userManager.signIn(email: email, password: password)
                        await bookshelvesManager.fetchBookshelves()
                    }
                })
                .padding(.top)
                .disabled(!validForm)
                .opacity(validForm ? 1.0 : 0.3)
                
                Button {
                    hasAccount.toggle()
                } label: {
                    Text("Don't have an account? Sign up!")
                        .underline()
                        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .alert(isPresented: $showLoginAlert){
                Alert (
                    title: Text("Sign in failed"),
                    message: Text("Please make sure that you have entered the correct email address and password."),
                    dismissButton: .cancel(Text("Ok")) {})
            }
        }
        .backgroundStyle(userManager.currentTheme.toolbarColor)
        .cornerRadius(30)
    }
    
    var signUp: some View {
        GroupBox {
            VStack (alignment: .center, spacing: 25) {
                Text("Sign Up")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(userManager.currentTheme.fontColor)
                    .padding(.bottom)
                ScrollView {
                    TextFieldWithLabel(label: "Enter your email", placeholder: "", textValue: $email)
                    if (!email.isEmpty){
                        CheckListView(invalidMessage: "Invalid email format.", validMessage: "Valid email", isValid: validEmail)
                    }
                    
                    SecureTextFieldWithEye(label: "Enter your password", placeholder: "", textValue: $password)
                    if (!password.isEmpty){
                        CheckListView(invalidMessage: "Password must be at be at least 8 characters long and contain an uppercase letter, a number, and a special character.", validMessage: "Valid password", isValid: validPassword)
                    }
                    
                    SecureTextFieldWithEye(label: "Confirm your password", placeholder: "", textValue: $confirmPassword)
                    if (!confirmPassword.isEmpty){
                        CheckListView(invalidMessage: "Passwords don't match.", validMessage: "Passwords match.", isValid: validConfirmPassword)
                    }
                    
                    TextFieldWithLabel(label: "Enter your username", placeholder: "", textValue: $username)
                    Text("Your username is for display only on your profile.")
                        .font(.caption)
                        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button1(label: "Sign Up", clicked: {
                    Task {
                        showSignupAlert = try await userManager.register(email: email, password: password, username: username)
                        try await bookshelvesManager.createNewBookshelves()
                    }
                })
                .padding(.top)
                .disabled(!validForm)
                .opacity(validForm ? 1.0 : 0.3)
                
                Button {
                    hasAccount.toggle()
                } label: {
                    Text("Already have an account? Sign in!")
                        .underline()
                        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                        .multilineTextAlignment(.center)
                }
            }
            .padding()
            .alert(isPresented: $showSignupAlert){
                Alert (
                    title: Text("Sign up failed"),
                    message: Text("An account with this email already exists. Please use \"Sign In\" instead if you already have an account"),
                    dismissButton: .cancel(Text("Ok")) {})
            }
        }
        .backgroundStyle(userManager.currentTheme.toolbarColor)
        .cornerRadius(30)
    }
}

extension SignedOutView: FormAuthProtocol {
    var validForm: Bool {
        if hasAccount { // sign in
            return !email.isEmpty
            && !password.isEmpty
        } else { // sign up
            return validEmail
            && validPassword
            && validConfirmPassword
            && !username.isEmpty
        }
    }
}

struct SignedOutView_Previews: PreviewProvider {
    static var previews: some View {
        SignedOutView()
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
    }
}
