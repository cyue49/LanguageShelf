import SwiftUI
import Firebase
import PhotosUI

struct SignedInView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    @State private var profilePic: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    
    var body: some View {
        if let user = userManager.currentUser {
            VStack (alignment: .center, spacing: 25) {
                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                    switch userManager.currentTheme.name {
                    case "default":
                        Image(uiImage: profilePic ?? UIImage(resource: .profileBlue))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(.circle)
                            .overlay(
                                    Circle()
                                        .stroke(userManager.currentTheme.primaryAccentColor, lineWidth: 5)
                                )
                    case "light":
                        Image(uiImage: profilePic ?? UIImage(resource: .profileLight))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(.circle)
                            .overlay(
                                    Circle()
                                        .stroke(userManager.currentTheme.primaryAccentColor, lineWidth: 5)
                                )
                    case "dark":
                        Image(uiImage: profilePic ?? UIImage(resource: .profileDark))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(.circle)
                            .overlay(
                                    Circle()
                                        .stroke(userManager.currentTheme.primaryAccentColor, lineWidth: 5)
                                )
                    case "green":
                        Image(uiImage: profilePic ?? UIImage(resource: .profileGreen))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(.circle)
                            .overlay(
                                    Circle()
                                        .stroke(userManager.currentTheme.primaryAccentColor, lineWidth: 5)
                                )
                    default:
                        Circle()
                            .fill(userManager.currentTheme.buttonColor)
                            .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                            .frame(width: 150, height: 150)
                            .padding(.top)
                    }
                }
                .padding(.top)
                .onChange(of: photosPickerItem) {
                    Task{
                        if let photosPickerItem,
                           let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                            if let image = UIImage(data: data){
                                profilePic = image
                            }
                        }
                        photosPickerItem = nil
                    }
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
