import SwiftUI
import Firebase

struct SignedInView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var body: some View {
        if let user = userManager.currentUser {
            VStack (alignment: .center, spacing: 25) {
                Circle()
                    .fill(Color("ButtonColor"))
                    .stroke(Color("IconColor"), lineWidth: 2)
                    .frame(width: 150, height: 150)
                    .padding(.top)
                
                Text(user.username)
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, maxHeight: 20)
                    .padding(.bottom)
                
                ChooseColorThemeView()
                
                Spacer()
            }
            .padding()
        }
        
//        VStack (alignment: .center, spacing: 25) {
//            Circle()
//                .fill(Color("ButtonColor"))
//                .stroke(Color("IconColor"), lineWidth: 2)
//                .frame(width: 150, height: 150)
//                .padding(.top)
//            
//            Text("Username")
//                .font(.largeTitle)
//                .frame(maxWidth: .infinity, maxHeight: 20)
//                .padding(.bottom)
//            
//            ChooseColorThemeView()
//            
//            Spacer()
//        }
//        .padding()
    }
}

struct SignedInView_Previews: PreviewProvider {
    static var previews: some View {
        SignedInView()
            .environmentObject(UserAccountsManager())
    }
}
