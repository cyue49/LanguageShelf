import SwiftUI
import Firebase
import FirebaseStorage
import PhotosUI

struct EditProfileView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    @State var profilePic: UIImage?
    @State var photosPickerItem: PhotosPickerItem?
    
    @Binding var updated: Bool
    
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
                                .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
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
                            
                            Button2(label: "Delete profile picture") {
                                removeProfilePicture()
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(userManager.currentTheme.secondaryColor,
                                        lineWidth: 2)
                        )
                        
                        // Edit username
                        VStack (spacing: 20) {
                            Text("Username: ")
                                .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            EditTextFieldView(updateField: "username", inputText: user.username, maxLength: 12)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(userManager.currentTheme.secondaryColor,
                                        lineWidth: 2)
                        )
                        
                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal){
                    Text("Edit Profile")
                        .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                }
            }
            .toolbarBackground(userManager.currentTheme.toolbarColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
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
                    updated.toggle()
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
                updated.toggle()
            }
            
            // update frontend
            DispatchQueue.main.async {
                profilePic = nil
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

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(updated: .constant(true))
            .environmentObject(UserAccountsManager())
    }
}
