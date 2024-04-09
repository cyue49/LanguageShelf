import SwiftUI
import Firebase
import FirebaseStorage
import PhotosUI

struct SignedInView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    @State var profilePic: UIImage?
    @State var updated: Bool = false
    
    var body: some View {
        if let user = userManager.currentUser {
            NavigationStack {
                VStack (alignment: .center, spacing: 15) {
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
                   
                    //EditTextFieldView(updateField: "username", inputText: user.username, maxLength: 12)
                    Text(user.username)
                        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                        .font(.title)
                        .bold()
                    
                    NavigationLink(destination: EditProfileView(updated: $updated)
                    ){
                        Text("Edit profile")
                    }
                    
                    ChooseColorThemeView()
                }
                .padding()
                .onAppear(){
                    // retrieve and set profile picture if user has a choosen profile picture
                    if !user.profilePicture.isEmpty {
                        setProfilePicFromStorage()
                    }
                }
                .onChange(of: updated){
                        // retrieve and set profile picture if user has a choosen profile picture
                        if !user.profilePicture.isEmpty {
                            setProfilePicFromStorage()
                        } else {
                            profilePic = nil
                        }
                }
            }
        }
    }
    
    func setProfilePicFromStorage() {
        if let user = userManager.currentUser {
            // storage reference
            let storageRef = Storage.storage().reference()
            
            // file path and name
            let filePath = user.profilePicture
            let fileRef = storageRef.child(filePath)
            
            // retrieve data
            fileRef.getData(maxSize: 6 * 1024 * 1024) { data, error in
                if error == nil && data != nil {
                    // create UIImage and set it as profilePic
                    let image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        profilePic = image
                    }
                }
            }
        }
    }
}

struct SignedInView_Previews: PreviewProvider {
    static var previews: some View {
        SignedInView()
            .environmentObject(UserAccountsManager())
    }
}
