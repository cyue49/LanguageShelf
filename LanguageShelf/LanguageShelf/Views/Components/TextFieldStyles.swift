import SwiftUI

struct TextFieldWithLabel: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var label: String
    var placeholder: String
    @Binding var textValue: String
    var isSecureField: Bool = false
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text(label)
                    .foregroundStyle(userManager.currentTheme.fontColor)
                Image(systemName: "asterisk")
                    .foregroundStyle(.red)
                    .font(.system(size: 8))
            }
            if isSecureField {
                ZStack {
                    SecureField(placeholder, text: $textValue)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .padding(12)
                        .background(userManager.currentTheme.bgColor)
                        .foregroundStyle(userManager.currentTheme.fontColor)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                        )
                }
            } else {
                TextField(placeholder, text: $textValue)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding(12)
                    .background(userManager.currentTheme.bgColor)
                    .foregroundStyle(userManager.currentTheme.fontColor)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                    )
            }
        }
    }
}

struct TextFieldWithoutLabel: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var placeholder: String
    @Binding var textValue: String
    
    var body: some View {
        TextField(placeholder, text: $textValue)
            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
            .padding(12)
            .background(userManager.currentTheme.bgColor)
            .foregroundStyle(userManager.currentTheme.fontColor)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
            )
    }
}

struct TextFieldStyles_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithLabel(label: "Question", placeholder: "Input", textValue: .constant("Input"))
            .environmentObject(UserAccountsManager())
    }
}
