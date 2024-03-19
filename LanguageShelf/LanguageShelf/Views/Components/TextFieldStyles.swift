import SwiftUI

struct TextFieldWithLabel: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var label: String
    var placeholder: String
    @Binding var textValue: String
    var isSecureField: Bool = false
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text(label)
                    .foregroundStyle(themeManager.currentTheme.fontColor)
                Image(systemName: "asterisk")
                    .foregroundStyle(.red)
                    .font(.system(size: 8))
            }
            if isSecureField {
                ZStack {
                    SecureField(placeholder, text: $textValue)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .padding(12)
                        .background(themeManager.currentTheme.bgColor)
                        .foregroundStyle(themeManager.currentTheme.fontColor)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(themeManager.currentTheme.secondaryColor, lineWidth: 2)
                        )
                }
            } else {
                TextField(placeholder, text: $textValue)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding(12)
                    .background(themeManager.currentTheme.bgColor)
                    .foregroundStyle(themeManager.currentTheme.fontColor)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(themeManager.currentTheme.secondaryColor, lineWidth: 2)
                    )
            }
        }
    }
}

struct TextFieldStyles_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithLabel(label: "Question", placeholder: "Input", textValue: .constant("Input"))
            .environmentObject(ThemeManager())
    }
}
