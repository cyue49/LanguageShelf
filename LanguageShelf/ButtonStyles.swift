import SwiftUI

struct Button1: View {
    var label: String
    var clicked: () -> Void
    
    var body: some View {
        Button(action: clicked) {
            Text(label)
                .frame(maxWidth: .infinity)
        }
        .padding(15)
        .background(Color("ButtonColor"))
        .foregroundStyle(Color("FontColor"))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("IconColor"), lineWidth: 2)
        )
    }
}


struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        Button1(label: "Button", clicked: {})
    }
}
