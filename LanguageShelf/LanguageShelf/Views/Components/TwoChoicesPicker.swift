import SwiftUI

struct TwoChoicesPicker: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    @Binding var choice: Int
    var choice1: String
    var choice2: String
    
    var body: some View {
        HStack {
            ZStack {
                if choice == 0 {
                    userManager.currentTheme.primaryAccentColor
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .cornerRadius(20)
                    Text(choice1)
                        .foregroundStyle(.white)
                        .bold()
                } else {
                    userManager.currentTheme.bgColor
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(userManager.currentTheme.primaryAccentColor, lineWidth: 2)
                        )
                    Text(choice1)
                        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                        .bold()
                }
            }
            .onTapGesture {
                choice = 0
            }
            ZStack {
                if choice == 1 {
                    userManager.currentTheme.primaryAccentColor
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .cornerRadius(20)
                    Text(choice2)
                        .foregroundStyle(.white)
                        .bold()
                } else {
                    userManager.currentTheme.bgColor
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(userManager.currentTheme.primaryAccentColor, lineWidth: 2)
                        )
                    Text(choice2)
                        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                        .bold()
                }
            }
            .onTapGesture {
                choice = 1
            }
        }
    }
}

struct TwoChoicesPicker_Previews: PreviewProvider {
    static var previews: some View {
        TwoChoicesPicker(choice: .constant(0), choice1: "Vocabulary", choice2: "Sentence")
            .environmentObject(UserAccountsManager())
    }
}
