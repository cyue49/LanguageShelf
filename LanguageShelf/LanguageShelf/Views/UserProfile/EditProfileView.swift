import SwiftUI
import Firebase
import FirebaseStorage
import PhotosUI

struct EditProfileView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    @Binding var profilePic: UIImage?
    @State var photosPickerItem: PhotosPickerItem?
    
    @State var newUsername = ""
    
    var body: some View {
        if let user = userManager.currentUser {
            ZStack {
                userManager.currentTheme.bgColor
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack (alignment: .center, spacing: 20) {
                        // edit profile picture
                        VStack (spacing: 20) {
                            Text("Profile Picture: ")
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
                            
                            Button(action: {
                                removeProfilePicture()
                            }, label: {
                                Label("Delete profile picture", systemImage: "x.circle.fill")
                                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                    .font(.system(size: 20))
                            })
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(userManager.currentTheme.primaryAccentColor,
                                        lineWidth: 2)
                        )
                        
                        // Edit username
                        VStack (spacing: 20) {
                            Text("Username: ")
                            EditTextFieldView(updateField: "username", inputText: user.username, maxLength: 12)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(userManager.currentTheme.primaryAccentColor,
                                        lineWidth: 2)
                        )
                        
                        Spacer()
                    }
                    .padding()
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
    
    func removeProfilePicture() {
        if let user = userManager.currentUser {
            // storage reference
            let storageRef = Storage.storage().reference()
            
            // file path and name
            let filePath = user.profilePicture
            let fileRef = storageRef.child(filePath)
            
            // delete
            Task {
                // delete file in firebase storage
                try await fileRef.delete()
                
                // remove reference to file in firestore database
                try await userManager.updateUser(attribute: "profilePicture", value: "")
            }
            
            // update frontend
            DispatchQueue.main.async {
                profilePic = nil
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(profilePic: .constant(nil))
            .environmentObject(UserAccountsManager())
    }
}
