import SwiftUI

struct TextFieldWithLabel: View {
    var label: String
    var placeholder: String
    @Binding var textValue: String
    var isSecureField: Bool = false
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(label)
                .foregroundStyle(Color("FontColor"))
            if isSecureField {
                SecureField(placeholder, text: $textValue)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding(12)
                    .background(Color("BackgroundColor"))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("IconColor"), lineWidth: 2)
                    )
            } else {
                TextField(placeholder, text: $textValue)
                    .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                    .padding(12)
                    .background(Color("BackgroundColor"))
                    .cornerRadius(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color("IconColor"), lineWidth: 2)
                    )
            }
        }
    }
}

struct TextFieldStyles_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithLabel(label: "Question", placeholder: "Input", textValue: .constant("Input"))
    }
}
