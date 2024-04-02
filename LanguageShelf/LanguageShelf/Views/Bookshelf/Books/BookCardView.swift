import SwiftUI
import Firebase
import FirebaseStorage
import PhotosUI

struct BookCardView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var bookshelvesManager: BookshelvesManager
    @EnvironmentObject var booksManager: BooksManager
    @EnvironmentObject var vocabsManager: VocabulariesManager
    @EnvironmentObject var sentencesManager: SentencesManager
    
    var bookshelf: Bookshelf
    var book: Book
    
    @State var showEditNameAlert: Bool = false
    @State var showBookAlreadyExistsAlert: Bool = false
    @State var emptyBookNameAlert: Bool = false
    @State var showBookInfo: Bool = false
    @State var showConfirmDeleteAlert: Bool = false
    
    @State var newBookName: String = ""
    
    @State private var coverPic: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    
    var body: some View {
        VStack {
            ZStack {
                NavigationLink(destination: VocabulariesView(book: book)) {
                    ZStack {
                        if coverPic == nil {
                            Rectangle()
                                .foregroundColor(userManager.currentTheme.bgColor)
                                .frame(maxWidth: 100, minHeight: 120, maxHeight: 120)
                                .cornerRadius(20)
                        } else {
                            ZStack {
                                Image(uiImage: coverPic!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: 100, minHeight: 120, maxHeight: 120)
                                    .cornerRadius(20)
                                
                                Rectangle()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: 100, minHeight: 120, maxHeight: 120)
                                    .cornerRadius(20)
                                    .opacity(0.5)
                            }
                        }
                        VStack (alignment: .leading) {
                            Image(systemName: "book.closed.fill")
                                .foregroundStyle(coverPic == nil ? userManager.currentTheme.primaryAccentColor : userManager.currentTheme.bgColor)
                                .font(.system(size: 28))
                        }
                        .padding(6)
                        .frame(maxWidth: 100, minHeight: 120, maxHeight: 120, alignment: .leading)
                        .backgroundStyle(userManager.currentTheme.bgColor2)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
                        )
                    }
                }
                
                HStack {
                    Spacer()
                    VStack (spacing: 10) {
                        Menu {
                            Button("Show Book Info") {
                                showBookInfo.toggle()
                            }
                            Button("Delete Book") {
                                showConfirmDeleteAlert.toggle()
                            }
                        } label: {
                            Image(systemName: "square.and.pencil.circle.fill")
                                .foregroundStyle(coverPic == nil ? userManager.currentTheme.primaryAccentColor : userManager.currentTheme.bgColor)
                                .font(.system(size: 24))
                        }
                        
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
                    }
                }
                .padding(6)
                .frame(maxWidth: 100, minHeight: 120, maxHeight: 120)
            }
            
            Text(book.title)
                .foregroundStyle(userManager.currentTheme.fontColor)
                .frame(maxWidth: 100)
                .lineLimit(2)
                .bold()
            Spacer()
        }
        .sheet(isPresented: $showBookInfo){
            BookInfoSheetView(bookshelf: bookshelf, book: book, showBookInfo: $showBookInfo)
        }
        .alert(isPresented: $showConfirmDeleteAlert) {
            Alert (
                title: Text("Confirm delete"),
                message: Text("Are you sure you want to delete this book? Everything inside this book will also be deleted."),
                primaryButton: .destructive(Text("Delete")) {
                    deleteBook(bookID: book.id)
                },
                secondaryButton: .cancel()
            )
        }
        .onAppear(){
            // retrieve and set cover picture if user has a choosen cover picture for this bookshelf
            if !book.picture.isEmpty {
                setPictureFromStorage()
            }
        }
    }
    
    func deleteBook(bookID: String) {
        Task {
            // remove this book
            try await booksManager.removeBook(bookID: bookID)
            
            // remove all vocabs in this book
            if let allVocabsInThisBook = vocabsManager.myVocabularies[bookID] {
                for vocab in allVocabsInThisBook {
                    try await vocabsManager.removeVocabulary(vocabularyID: vocab.id)
                }
            }
            
            // remove all sentences in this book
            if let allSentencesInThisBook = sentencesManager.mySentences[bookID] {
                for sentence in allSentencesInThisBook {
                    try await sentencesManager.removeSentence(sentenceID: sentence.id)
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
        let filePath = "book/\(book.id)-cover-pic.jpg"
        let fileRef = storageRef.child(filePath)
        
        // upload data
        _ = fileRef.putData(imageData!, metadata: nil) { metadata, error in
            if error == nil && metadata != nil {
                // save reference to file in firestore database
                Task {
                    try await booksManager.updatePicture(bookID: book.id, picturePath: filePath)
                }
            }
        }
    }
    
    func setPictureFromStorage() {
        // storage reference
        let storageRef = Storage.storage().reference()
        
        // file path and name
        let filePath = book.picture
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
        let filePath = book.picture
        let fileRef = storageRef.child(filePath)
        
        // delete
        Task {
            // delete file in firebase storage
            try await fileRef.delete()
            
            // remove reference to file in firestore database
            try await booksManager.updatePicture(bookID: book.id, picturePath: "")
        }
        
        // update frontend
        DispatchQueue.main.async {
            coverPic = nil
        }
    }
}

struct BookCardView_Previews: PreviewProvider {
    static var previews: some View {
        BookCardView(bookshelf: Bookshelf(userID: "123", bookshelfName: "English Books"),
                     book: Book(bookshelfID: "bookshelfID", userID: "userID", title: "The Penguin Detective"))
        .environmentObject(UserAccountsManager())
        .environmentObject(BookshelvesManager())
        .environmentObject(BooksManager())
        .environmentObject(VocabulariesManager())
        .environmentObject(SentencesManager())
    }
}
