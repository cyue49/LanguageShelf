import SwiftUI

struct Button1: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var label: String
    var clicked: () -> Void
    
    var body: some View {
        Button(action: clicked) {
            Text(label)
                .frame(maxWidth: .infinity)
                .bold()
        }
        .padding(15)
        .background(userManager.currentTheme.primaryAccentColor)
        .foregroundStyle(.white)
        .cornerRadius(20)
    }
}

struct Button2: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var label: String
    var clicked: () -> Void
    
    var body: some View {
        Button(action: clicked) {
            Text(label)
                .frame(maxWidth: .infinity)
                .bold()
        }
        .padding(15)
        .background(userManager.currentTheme.bgColor)
        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(userManager.currentTheme.primaryAccentColor, lineWidth: 2)
        )
    }
}


struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        Button1(label: "Button", clicked: {})
            .environmentObject(UserAccountsManager())
        Button2(label: "Button", clicked: {})
            .environmentObject(UserAccountsManager())
    }
}
