import SwiftUI

struct ChooseColorThemeView: View {
    var body: some View {
        VStack {
            Text("Choose a Color Theme")
                .frame(maxWidth: .infinity, maxHeight: 400)
                .background(RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .foregroundStyle(.white)
                    .frame(height: 400))
                .overlay(RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(Color("IconColor"), lineWidth: 2)
                    .frame(height: 400))
        }
    }
}

struct ChooseColorThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseColorThemeView()
    }
}
