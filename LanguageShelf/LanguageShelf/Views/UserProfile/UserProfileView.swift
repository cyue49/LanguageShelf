import SwiftUI

struct UserProfileView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("User Profile")
            }
            .navigationTitle("User Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading){
                    Text("Logo")
                }
            }
            .toolbarBackground(Color("ToolBarColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
