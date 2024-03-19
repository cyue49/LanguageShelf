import SwiftUI

struct ColorThemeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var colorSet: [Color]
    var label: String
    
    var body: some View {
        VStack (alignment: .leading) {
            Text(label)
                .font(.headline)
                .foregroundStyle(themeManager.currentTheme.fontColor)
            HStack (spacing: 25) {
                ForEach(colorSet, id: \.self) { color in
                    Rectangle()
                        .fill(color)
                        .frame(width: 40, height: 40)
                }
            }
        }
        .frame(alignment: .leading)
    }
}

struct ColorThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ColorThemeView(colorSet: [Color("1-PrimaryAccentColor"),Color("1-SecondaryColor"), Color("1-ToolbarColor"), Color("1-ButtonColor"), Color("1-BackgroundColor")], label: "Default Theme")
            .environmentObject(ThemeManager())
    }
}
