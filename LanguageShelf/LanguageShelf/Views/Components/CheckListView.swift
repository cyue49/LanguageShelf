import SwiftUI

struct CheckListView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var invalidMessage: String
    var validMessage: String
    var isValid: Bool
    
    var body: some View {
        HStack {
            Label(isValid ? validMessage : invalidMessage, systemImage: isValid ? "checkmark.circle.fill" : "xmark.circle.fill")
                .foregroundColor(isValid ? themeManager.currentTheme.primaryAccentColor : .red)
                .font(.caption)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct CheckListView_Previews: PreviewProvider {
    static var previews: some View {
        CheckListView(invalidMessage: "Invalid format", validMessage: "Valid format", isValid: true)
            .environmentObject(ThemeManager())
    }
}
