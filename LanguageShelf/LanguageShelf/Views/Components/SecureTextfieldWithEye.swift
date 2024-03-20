import SwiftUI

struct SecureTextFieldWithEye: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var label: String
    var placeholder: String
    @Binding var textValue: String
    @State var showInput: Bool = false
    
    var body: some View {
        ZStack {
            if showInput {
                TextFieldWithLabel(label: label, placeholder: "", textValue: $textValue)
            } else {
                TextFieldWithLabel(label: label, placeholder: "", textValue: $textValue, isSecureField: true)
            }
            
            HStack {
                Spacer()
                Button(action: {
                    showInput.toggle()
                }, label: {
                    Image(systemName: showInput ? "eye.slash.fill" : "eye.fill")
                        .padding()
                        .offset(y: 15)
                        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
            })
            }
        }
    }
}

struct SecureTextFieldWithEye_Previews: PreviewProvider {
    static var previews: some View {
        SecureTextFieldWithEye(label: "Question", placeholder: "Input", textValue: .constant("Input"))
            .environmentObject(UserAccountsManager())
    }
}
