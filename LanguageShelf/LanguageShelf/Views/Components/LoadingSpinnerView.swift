import SwiftUI

struct LoadingSpinnerView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    @Binding var showLoadingSpinner: Bool
    var loadTime: Double
    
    var body: some View {
        if showLoadingSpinner {
            ZStack {
//                Color(.white)
//                    .opacity(0.9)
//                    .ignoresSafeArea()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: userManager.currentTheme.primaryAccentColor))
                    .scaleEffect(1.5, anchor: .center)
                    .onAppear(){
                        DispatchQueue.main.asyncAfter(deadline: .now() + loadTime) {
                            showLoadingSpinner.toggle()
                        }
                    }
            }
        }
    }
}

struct LoadingSpinnerView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingSpinnerView(showLoadingSpinner: .constant(true), loadTime: 2.0)
            .environmentObject(UserAccountsManager())
    }
}
