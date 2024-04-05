import SwiftUI

struct GamePlayCorrectIncorrectView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    @Binding var showAlert: Bool
    @Binding var correct: Bool
    
    var body: some View {
        if showAlert {
            ZStack {
                Color(.white)
                    .opacity(0)
                    .ignoresSafeArea()
                
                Rectangle()
                    .foregroundColor(userManager.currentTheme.bgColor)
                    .frame(width: 150, height: 150)
                    .cornerRadius(30)
                    .opacity(0.9)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(correct ? userManager.currentTheme.primaryAccentColor : .red, lineWidth: 2)
                    )
                
                VStack(spacing: 20) {
                    Image(systemName: correct ? "checkmark.circle.fill" : "x.circle.fill")
                        .foregroundStyle(correct ? userManager.currentTheme.primaryAccentColor : .red)
                        .font(.system(size: 30))
                        .onAppear(){
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                showAlert.toggle()
                                correct = false
                            }
                        }
                    Text(correct ? "Correct!" : "Wrong!")
                        .foregroundStyle(correct ? userManager.currentTheme.primaryAccentColor : .red)
                        .bold()
                }
            }
        }
    }
}

struct GamePlayCorrectIncorrectView_Previews: PreviewProvider {
    static var previews: some View {
        GamePlayCorrectIncorrectView(showAlert: .constant(true), correct: .constant(true))
            .environmentObject(UserAccountsManager())
    }
}
