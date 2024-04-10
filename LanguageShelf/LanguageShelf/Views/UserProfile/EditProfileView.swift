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
    @State var newPassword: String = ""
    @State var confirmPassword: String = ""
    
    private var validEmail: Bool {
        return !newEmail.isEmpty
        && newEmail.contains("@")
        && newEmail.contains(".")
    }
    
    private var validPassword: Bool {
        let passwordRegex = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[A-Z]+.*)(?=.*[0-9]+.*)(?=.*[!&^%$#@()/_*+-]+.*).{8,}$")
        
        return !newPassword.isEmpty
        && newPassword.count>=8
        && passwordRegex.evaluate(with: newPassword)
    }
    
    private var validConfirmPassword: Bool {
        return !confirmPassword.isEmpty
        && confirmPassword == newPassword
    }
    
    @State var showGeneralEmailErrorAlert: Bool = false
    @State var showGeneralErrorAlert: Bool = false
    
    @State var changeEmailVerificationSent: Bool = false
    @State var successPasswordUpdate: Bool = false
    
    @State var showReauthenticate: Bool = false
    @State var showReauthSuccess: Bool = false
    @State var showReauthFailed: Bool = false
    @State var currentEmail: String = ""
    @State var currentPwd: String = ""
    
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
                            
                            Text(currentEmail)
                                .foregroundStyle(userManager.currentTheme.fontColor)
                            
                            Text("New account email:")
                                .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            CustomTextField(placeholder: "Email", textValue: $newEmail, optional: false)
                            if (!newEmail.isEmpty){
                                CheckListView(invalidMessage: "Invalid email format.", validMessage: "Valid email", isValid: validEmail)
                            }
                            
                            if changeEmailVerificationSent {
                                Text("Verification email sent to your new email!")
                                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .bold()
                            }
                            
                            Button2(label: "Update account email") {
                                Task{
                                    do {
                                        try await userManager.updateUserEmail(newEmail: newEmail)
                                        changeEmailVerificationSent = true
                                    } catch {
                                        let err = error as NSError
                                        switch err {
                                        case AuthErrorCode.requiresRecentLogin:
                                            print("login needed")
                                            showReauthenticate = true
                                        default:
                                            showGeneralEmailErrorAlert.toggle()
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
                        
                        // Change password
                        VStack (spacing: 20) {
                            Text("Password: ")
                                .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .bold()
                            
                            SecureTextFieldWithEye(label: "Enter your new password", placeholder: "", textValue: $newPassword)
                            if (!newPassword.isEmpty){
                                CheckListView(invalidMessage: "Your password must be between 8-20 characters long and contain an uppercase letter, a number, and a special character.", validMessage: "Valid password", isValid: validPassword)
                            }
                            
                            SecureTextFieldWithEye(label: "Confirm your password", placeholder: "", textValue: $confirmPassword)
                            if (!confirmPassword.isEmpty){
                                CheckListView(invalidMessage: "Passwords don't match.", validMessage: "Passwords match.", isValid: validConfirmPassword)
                            }
                            
                            if successPasswordUpdate {
                                Text("Password updated successfully!")
                                    .foregroundStyle(userManager.currentTheme.primaryAccentColor)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .bold()
                            }
                            
                            Button2(label: "Update password") {
                                Task{
                                    do {
                                        try await userManager.updateUserPassword(newPassword: newPassword)
                                        successPasswordUpdate = true
                                        newPassword = ""
                                        confirmPassword = ""
                                    } catch {
                                        let err = error as NSError
                                        switch err {
                                        case AuthErrorCode.requiresRecentLogin:
                                            print("login needed")
                                            showReauthenticate = true
                                        default:
                                            showGeneralErrorAlert.toggle()
                                            print("\(error): \(error.localizedDescription)")
                                        }
                                    }
                                }
                            }
                            .disabled(!(validPassword && validConfirmPassword))
                            .opacity((validPassword && validConfirmPassword) ? 1.0 : 0.3)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(userManager.currentTheme.secondaryColor,
                                        lineWidth: 2)
                        )
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
                
                // set current email for display
                if let curUser = Auth.auth().currentUser {
                    if curUser.email != nil {
                        currentEmail = curUser.email!
                    }
                }
            }
            // invalid email and general email error alert
            .alert("Error", isPresented: $showGeneralEmailErrorAlert) {
                Button("Ok", role: .cancel){}
            } message: {
                Text("A verification email could not be sent. Please make sure you have entered the correct email address. If the problem persists, sign out then sign in again using your current email and password then try again.")
            }
            // general error alert
            .alert("Operation failed", isPresented: $showGeneralErrorAlert) {
                Button("Ok", role: .cancel){
                    dismiss()
                    Task {
                        userManager.signOut()
                    }
                }
            } message: {
                Text("Something went wrong. Please re-sign in to try again.")
            }
            // reauthenticate required
            .alert("Requthentication required:", isPresented: $showReauthenticate){
                TextField("Email", text: $currentEmail)
                    .autocapitalization(.none)
                SecureField("Password", text: $currentPwd)
                    .autocapitalization(.none)
                Button("Confirm") {
                    let credential = EmailAuthProvider.credential(withEmail: currentEmail, password: currentPwd)
                    Auth.auth().currentUser?.reauthenticate(with: credential, completion: { result, error in
                        if error != nil {
                            showReauthFailed .toggle()
                        } else {
                            showReauthSuccess.toggle()
                        }
                    })
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Please enter your current email and password to continue.")
            }
            // reauthentication success
            .alert("Reauthentication success!", isPresented: $showReauthSuccess) {
                Button("Ok", role: .cancel){
                    currentPwd = ""
                }
            } message: {
                Text("Please resubmit your changes to continue")
            }
            // reauthentication failed
            .alert("Reauthentication failed!", isPresented: $showReauthFailed) {
                Button("Ok", role: .cancel){
                    currentPwd = ""
                }
            } message: {
                Text("Please make sure you have entered the correct email and password.")
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
