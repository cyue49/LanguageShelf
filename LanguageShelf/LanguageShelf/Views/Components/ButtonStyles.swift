import SwiftUI

struct Button1: View {
    var label: String
    var clicked: () -> Void
    
    var body: some View {
        Button(action: clicked) {
            Text(label)
                .frame(maxWidth: .infinity)
                .bold()
        }
        .padding(15)
        .background(Color("PrimaryAccentColor"))
        .foregroundStyle(.white)
        .cornerRadius(20)
    }
}


struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        Button1(label: "Button", clicked: {})
    }
}
