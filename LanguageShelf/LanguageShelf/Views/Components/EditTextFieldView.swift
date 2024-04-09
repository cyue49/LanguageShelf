import SwiftUI

struct EditTextFieldView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var updateField: String
    var inputText: String
    var maxLength: Int
    
    @State var editText = ""
    @State var isEdit: Bool = false
    
    @State var emptyUsernameAlert: Bool = false
    
    var body: some View {
        HStack {
            Spacer()
            if isEdit {
                TextField("", text: $editText)
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
                    .font(.title)
                    .foregroundStyle(userManager.currentTheme.fontColor)
            }
            Spacer()
            
            Button (action: {
                if isEdit { // if user is in editing mode and confirms new username
                    Task {
                        do {
                            try await userManager.updateUser(attribute: updateField, value: editText)
                        } catch DataErrors.emptyNameError {
                            emptyUsernameAlert.toggle()
                        }
                    }
                } else { // if user not in editing mode and wants to edit username
                    editText = inputText
                }
                isEdit.toggle()
            }, label: {
                Image(systemName: isEdit ? "checkmark.square" : "square.and.pencil")
                    .font(.system(size: 20))
                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
            })
            Spacer()
        }
        .alert("Your username can't be empty.", isPresented: $emptyUsernameAlert){
            Button("Ok", role: .cancel) {
                emptyUsernameAlert = false
            }
        }
        .onChange(of: editText) {
            if editText.count > maxLength {
                editText = String(editText.prefix(maxLength))
            }
        }
    }
}

struct EditTextField_Previews: PreviewProvider {
    static var previews: some View {
        EditTextFieldView(updateField: "username", inputText: "Username", maxLength: 12)
            .environmentObject(UserAccountsManager())
    }
}
