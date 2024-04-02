import SwiftUI
import Firebase
import FirebaseStorage
import PhotosUI

struct BookshelfCardView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    var bookshelf: Bookshelf
    @State var showEditNameAlert: Bool = false
    @State var showBookshelfAlreadyExistsAlert: Bool = false
    @State var emptyBookshelfNameAlert: Bool = false
    @State var showConfirmDeleteAlert: Bool = false
    
    @State var newBookshelfName: String = ""
    
    @State private var coverPic: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    
    @Binding var showLoadingSpinner: Bool
    
    var body: some View {
        VStack {
            ZStack {
                NavigationLink(destination: MyBooksView(bookshelf: bookshelf)) {
                    ZStack {
                        if coverPic == nil {
                            Rectangle()
                                .foregroundColor(userManager.currentTheme.bgColor)
                                .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 150)
                                .cornerRadius(30)
                        } else {
                            ZStack {
                                Image(uiImage: coverPic!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 150)
                                    .cornerRadius(30)
                                
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 150)
                                    .cornerRadius(30)
                                    .opacity(0.5)
                            }
                        }
                        
                        VStack {
                            VStack {
                                Spacer()
                                HStack {
                                    Image(systemName: "books.vertical.fill")
                                        .foregroundStyle(coverPic == nil ? userManager.currentTheme.primaryAccentColor : userManager.currentTheme.bgColor)
                                        .font(.system(size: 60))
                                        .offset(x: -10, y: 10)
                                    
                                    VStack {
                                        Spacer()
                                        Text(bookshelf.bookshelfName)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .foregroundStyle(userManager.currentTheme.fontColor)
                                            .lineLimit(2)
                                            .bold()
                                    }
                                }
                                .padding(.leading, 25)
                                
                                Rectangle()
                                    .frame(maxWidth : .infinity, maxHeight: 20)
                                    .cornerRadius(30)
                                    .foregroundStyle(userManager.currentTheme.toolbarColor)
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 150)
                        .backgroundStyle(userManager.currentTheme.bgColor2)
                        .cornerRadius(30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 30)
                                .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                        )
                    }
                }
                
                VStack (spacing: 10){
                    Menu {
                        Button("Rename") {
                            newBookshelfName = bookshelf.bookshelfName
                            showEditNameAlert.toggle()
                        }
                        
                        Button("Delete") {
                            showConfirmDeleteAlert.toggle()
                        }
                    } label: {
                        Image(systemName: "square.and.pencil.circle.fill")
                            .foregroundStyle(coverPic == nil ? userManager.currentTheme.primaryAccentColor : userManager.currentTheme.bgColor)
                            .font(.system(size: 24))
                    }
                    .padding(0)
                    PhotosPicker(selection: $photosPickerItem, matching: .images) {
                        Image(systemName: "camera.circle.fill")
                            .foregroundStyle(coverPic == nil ? userManager.currentTheme.primaryAccentColor : userManager.currentTheme.bgColor)
                            .font(.system(size: 24))
                    }
                    .onChange(of: photosPickerItem) {
                        Task{
                            if let photosPickerItem,
                               let data = try? await photosPickerItem.loadTransferable(type: Data.self) {
                                if let image = UIImage(data: data){
                                    // update frontend view
                                    coverPic = image
                                    
                                    // save photo to firebase storage
                                    savePhotoToStorage()
                                }
                            }
                            photosPickerItem = nil
                        }
                    }
                    Button(action: {
                        // remove profile picture
                        removePicture()
                    }, label: {
                        Image(systemName: "x.circle.fill")
                            .foregroundStyle(coverPic == nil ? userManager.currentTheme.primaryAccentColor : userManager.currentTheme.bgColor)
                            .font(.system(size: 24))
                    })
                    Spacer()
                }
                .padding(10)
                .frame(maxWidth: .infinity, minHeight: 150, maxHeight: 150, alignment: .trailing)
            }
        }
        .alert("Enter the bookshelf's name:", isPresented: $showEditNameAlert){
            TextField("Bookshelf", text: $newBookshelfName)
            Button("Confirm") {
                Task {
                    do {
                        showLoadingSpinner = true
                        try await bookshelvesManager.renameBookshelf(bookshelfID: bookshelf.id, newName: newBookshelfName)
                    } catch DataErrors.existingNameError {
                        showBookshelfAlreadyExistsAlert.toggle()
                    } catch DataErrors.emptyNameError {
                        emptyBookshelfNameAlert.toggle()
                    }
                }
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("A bookshelf of this name already exists.", isPresented: $showBookshelfAlreadyExistsAlert){
            Button("Ok", role: .cancel) {
                showBookshelfAlreadyExistsAlert = false
            }
        }
        .alert("You must enter a name for your bookshelf.", isPresented: $emptyBookshelfNameAlert){
            Button("Ok", role: .cancel) {
                emptyBookshelfNameAlert = false
            }
        }
        .alert(isPresented: $showConfirmDeleteAlert) {
            Alert (
                title: Text("Confirm delete"),
                message: Text("Are you sure you want to delete this bookshelf? Everything inside this bookshelf will also be deleted."),
                primaryButton: .destructive(Text("Delete")) {
                    showLoadingSpinner = true
                    deleteBookshelf(bookshelfID: bookshelf.id)
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear(){
            // retrieve and set cover picture if user has a choosen cover picture for this bookshelf
            if !bookshelf.picture.isEmpty && coverPic == nil {
                setPictureFromStorage()
            }
        }
    }
    
    func deleteBookshelf(bookshelfID: String) {
        Task {
            // delete bookshelf cover picture from firebase storage if exists
            if bookshelf.picture != "" {
                let storageRef = Storage.storage().reference()
                let filePath = bookshelf.picture
                let fileRef = storageRef.child(filePath)
                try await fileRef.delete()
            }
            
            // delete this bookshelf from database
            try await bookshelvesManager.removeBookshelf(bookshelfID: bookshelf.id)
            
            // for all books in this bookshelf
            if let allBooksInThisBookshelf = booksManager.myBooks[bookshelfID] {
                for aBook in allBooksInThisBookshelf {
                    // delete book cover picture from firebase storage if exists
                    if aBook.picture != "" {
                        let storageRef = Storage.storage().reference()
                        let filePath = aBook.picture
                        let fileRef = storageRef.child(filePath)
                        try await fileRef.delete()
                    }
                    
                    // delete this book from database
                    try await booksManager.removeBook(bookID: aBook.id)
                    
                    // remove all vocabs in this book
                    if let allVocabsInThisBook = vocabsManager.myVocabularies[aBook.id] {
                        for vocab in allVocabsInThisBook {
                            try await vocabsManager.removeVocabulary(vocabularyID: vocab.id)
                        }
                    }
                    
                    // remove all sentences in this book
                    if let allSentencesInThisBook = sentencesManager.mySentences[aBook.id] {
                        for sentence in allSentencesInThisBook {
                            try await sentencesManager.removeSentence(sentenceID: sentence.id)
                        }
                    }
                }
            }
        }
    }
    
    func savePhotoToStorage() {
        guard coverPic != nil else { return }
        
        // storage reference
        let storageRef = Storage.storage().reference()
        
        // turn image into data
        let imageData = coverPic!.jpegData(compressionQuality: 0.8)
        guard imageData != nil else { return }
        
        // file path and name
        let filePath = "bookshelf/\(bookshelf.id)-cover-pic.jpg"
        let fileRef = storageRef.child(filePath)
        
        // upload data
        _ = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                // save reference to file in firestore database
                Task {
                    try await bookshelvesManager.updatePicture(bookshelfID: bookshelf.id, picturePath: filePath)
                }
            }
        }
    }
    
    func setPictureFromStorage() {
        // storage reference
        let storageRef = Storage.storage().reference()
        
        // file path and name
        let filePath = bookshelf.picture
        let fileRef = storageRef.child(filePath)
        
        // retrieve data
        fileRef.getData(maxSize: 6 * 1024 * 1024) { data, error in
            if error == nil && data != nil {
                // create UIImage and set it as profilePic
                let image = UIImage(data: data!)
                DispatchQueue.main.async {
                    coverPic = image
                }
            }
        }
    }
    
    func removePicture() {
        // storage reference
        let storageRef = Storage.storage().reference()
        
        // file path and name
        let filePath = bookshelf.picture
        let fileRef = storageRef.child(filePath)
        
        // delete
        Task {
            // delete file in firebase storage
            try await fileRef.delete()
            
            // remove reference to file in firestore database
            try await bookshelvesManager.updatePicture(bookshelfID: bookshelf.id, picturePath: "")
        }
        
        // update frontend
        DispatchQueue.main.async {
            coverPic = nil
        }
    }
}

struct BookshelfCardView_Previews: PreviewProvider {
    static var previews: some View {
        BookshelfCardView(bookshelf: Bookshelf(userID: "123", bookshelfName: "English Books"),
                          showLoadingSpinner: .constant(false))
            .environmentObject(UserAccountsManager())
            .environmentObject(BookshelvesManager())
            .environmentObject(BooksManager())
            .environmentObject(VocabulariesManager())
            .environmentObject(SentencesManager())
    }
}
