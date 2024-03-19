import SwiftUI

struct Button1: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var label: String
    var clicked: () -> Void
    
    var body: some View {
        Button(action: clicked) {
            Text(label)
                .frame(maxWidth: .infinity)
                .bold()
        }
        .padding(15)
        .background(themeManager.currentTheme.primaryAccentColor)
        .foregroundStyle(.white)
        .cornerRadius(20)
    }
}


struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        Button1(label: "Button", clicked: {})
            .environmentObject(ThemeManager())
    }
}
