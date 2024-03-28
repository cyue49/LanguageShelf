import SwiftUI

struct CheckboxStyle1: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var label: String
    @State var checked: Bool = false
    @Binding var addToList: [String]
    
    var body: some View {
        Button (action: {
            checked.toggle()
            if checked { // if checked, add this to list
                if !addToList.contains(label){
                    addToList.append(label)
                }
            } else { // if not checked, remove from list
                if let index = addToList.firstIndex(of: label) {
                    addToList.remove(at: index)
                }
            }
        }, label: {
            HStack () {
                Image(systemName: checked ? "checkmark.square.fill" : "square")
                    .foregroundColor(userManager.currentTheme.primaryAccentColor)
                Text(label)
                    .foregroundColor(userManager.currentTheme.fontColor)
            }
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            Rectangle()
                .foregroundColor(userManager.currentTheme.buttonColor)
                .cornerRadius(20)
        )
        .onAppear(){
            if addToList.contains(label){
                checked = true
            } else {
                checked = false 
            }
        }
    }
}

struct CheckboxStyles_Previews: PreviewProvider {
    static var previews: some View {
        CheckboxStyle1(label: "Test", checked: true, addToList: .constant([]))
            .environmentObject(UserAccountsManager())
    }
}
