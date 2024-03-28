import SwiftUI

struct CheckboxStyle1: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var label: String
    @Binding var checked: Bool
    
    var body: some View {
        Button (action: {
            checked.toggle()
        }, label: {
            HStack () {
                Image(systemName: checked ? "checkmark.square.fill" : "square")
                    .foregroundColor(userManager.currentTheme.primaryAccentColor)
                Text(label)
                    .foregroundColor(userManager.currentTheme.fontColor)
            }
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            Rectangle()
                .foregroundColor(userManager.currentTheme.buttonColor)
                .cornerRadius(20)
        )
    }
}

struct CheckboxStyles_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxStyle1(label: "Test", checked: .constant(false))
            .environmentObject(UserAccountsManager())
    }
}
