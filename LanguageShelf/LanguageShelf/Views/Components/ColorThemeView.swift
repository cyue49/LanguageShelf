import SwiftUI

struct ColorThemeView: View {
    var colorSet: [String]
    var label: String
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(label)
                .font(.headline)
            HStack (spacing: 25) {
                ForEach(colorSet, id: \.self) { color in
                    Rectangle()
                        .fill(Color(color))
                        .frame(width: 40, height: 40)
                }
            }
        }
        .frame(alignment: .leading)
    }
}

struct ColorThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ColorThemeView(colorSet: ["PrimaryAccentColor","IconColor", "ToolBarColor", "ButtonColor", "BackgroundColor"], label: "Default Theme")
    }
}
