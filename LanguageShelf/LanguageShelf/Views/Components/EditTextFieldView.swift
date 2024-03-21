import SwiftUI

struct EditTextFieldView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var updateField: String
    @State var inputText: String
    @State var isEdit: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            if isEdit {
                TextField("", text: $inputText)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding(12)
                    .background(userManager.currentTheme.bgColor)
                    .foregroundStyle(userManager.currentTheme.fontColor)
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                    )
            } else {
                Spacer()
                Text(inputText)
                    .font(.largeTitle)
                    .foregroundStyle(userManager.currentTheme.fontColor)
            }
            Spacer()
            
            Button (action: {
                isEdit.toggle()
                Task {
                    try await userManager.updateUser(attribute: updateField, value: inputText)
                }
            }, label: {
                Image(systemName: isEdit ? "checkmark.square" : "square.and.pencil")
                    .font(.title)
                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
            })
            Spacer()
        }
    }
}

struct EditTextField_Previews: PreviewProvider {
    static var previews: some View {
        EditTextFieldView(updateField: "username", inputText: "Username")
            .environmentObject(UserAccountsManager())
    }
}
