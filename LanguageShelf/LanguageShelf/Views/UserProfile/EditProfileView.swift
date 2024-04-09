import SwiftUI
import Firebase
import FirebaseStorage
import PhotosUI

struct EditProfileView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    @State var profilePic: UIImage?
    @State var photosPickerItem: PhotosPickerItem?
    
    @Binding var updated: Bool
    
    @State var newEmail: String = ""
    private var validEmail: Bool {
        return !newEmail.isEmpty
        && newEmail.contains("@")
        && newEmail.contains(".")
    }
    
    @State var showReLoginAlert: Bool = false
    @State var showGeneralErrorAlert: Bool = false
    
    @Environment(\.dismiss) var dismiss
    
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
                                .bold()
                            
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
                                .bold()
                            
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
                        
                        // Change email
                        VStack (spacing: 20) {
                            Text("Email: ")
                                .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .bold()
                            
                            Text("Current account email: ")
                                .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text(Auth.auth().currentUser!.email!)
                                .foregroundStyle(userManager.currentTheme.fontColor)
                            
                            Text("New account email:")
                                .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            CustomTextField(placeholder: "Email", textValue: $newEmail, optional: false)
                            if (!newEmail.isEmpty){
                                CheckListView(invalidMessage: "Invalid email format.", validMessage: "Valid email", isValid: validEmail)
                            }
                            
                            Button2(label: "Update account email") {
                                Task{
                                    do {
                                        try await userManager.updateUserEmail(newEmail: newEmail)
                                    } catch {
                                        let err = error as NSError
                                        switch err {
                                        case AuthErrorCode.requiresRecentLogin:
                                            print("login needed")
                                            showReLoginAlert.toggle()
                                        default:
                                            showGeneralErrorAlert.toggle()
                                            print("\(error): \(error.localizedDescription)")
                                        }
                                    }
                                }
                            }
                            .disabled(!validEmail)
                            .opacity(validEmail ? 1.0 : 0.3)
                            
                            Text("A verification email will be sent to the new email address you have entered once you click on Update acount email. Please follow the link in the email to finish updating your account email. Please note that the display on this page won't update until you sign out and sign in again after you have followed the verification link send to your new email.")
                                .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.caption)
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
            .alert(isPresented: $showReLoginAlert) {
                Alert (
                    title: Text("Sign in again to continue"),
                    message: Text("This operation requires to sign in again to continue. Please sign in and try again."),
                    dismissButton: .default(Text("Ok")) {
                        dismiss()
                        Task {
                            userManager.signOut()
                        }
                    }
                )
            }
            .alert(isPresented: $showGeneralErrorAlert) {
                Alert (
                    title: Text("Invalid email"),
                    message: Text("A verification email could not be sent. Please make sure you have entered the correct email address."),
                    dismissButton: .default(Text("Ok"))
                )
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
