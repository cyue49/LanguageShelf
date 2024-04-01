import SwiftUI
import Firebase

struct SignedInView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    @State private var profilePic: UIImage?
    
    var body: some View {
        if let user = userManager.currentUser {
            VStack (alignment: .center, spacing: 25) {
                switch userManager.currentTheme.name {
                case "default":
                    Image(uiImage: profilePic ?? UIImage(resource: .profileBlue))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .padding(.top)
                        .clipShape(.circle)
                case "light":
                    Image(uiImage: profilePic ?? UIImage(resource: .profileLight))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .padding(.top)
                        .clipShape(.circle)
                case "dark":
                    Image(uiImage: profilePic ?? UIImage(resource: .profileDark))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .padding(.top)
                        .clipShape(.circle)
                case "green":
                    Image(uiImage: profilePic ?? UIImage(resource: .profileGreen))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .padding(.top)
                        .clipShape(.circle)
                default:
                    Circle()
                        .fill(userManager.currentTheme.buttonColor)
                        .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                        .frame(width: 150, height: 150)
                        .padding(.top)
                }
                
                EditTextFieldView(updateField: "username", inputText: user.username)
                
                ChooseColorThemeView()
                
                Spacer()
            }
            .padding()
        }
    }
}

struct SignedInView_Previews: PreviewProvider {
    static var previews: some View {
        SignedInView()
            .environmentObject(UserAccountsManager())
    }
}
