import SwiftUI
import Firebase
import FirebaseStorage
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
                                // update frontend view
                                profilePic = image
                                
                                // save photo to firebase storage
                                savePhotoToStorage()
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
            .onAppear(){
                // retrieve and set profile picture if user has a choosen profile picture
                if !user.profilePicture.isEmpty {
                    setProfilePicFromStorage()
                }
            }
        }
    }
    
    func savePhotoToStorage() {
        guard profilePic != nil else { return }
        
        // storage reference
        let storageRef = Storage.storage().reference()
        
        // turn image into data
        let imageData = profilePic!.jpegData(compressionQuality: 0.8)
        guard imageData != nil else { return }
        
        // file path and name
        guard let uid = userManager.currentUser?.id else { return }
        let filePath = "profile/\(uid)-profile-pic.jpg"
        let fileRef = storageRef.child(filePath)
        
        // upload data
        _ = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                // save reference to file in firestore database
                Task {
                    try await userManager.updateUser(attribute: "profilePicture", value: filePath)
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
                    profilePic = image
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
