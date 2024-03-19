import SwiftUI

struct ChooseColorThemeView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        GroupBox {
            VStack (alignment: .leading, spacing: 20) {
                Text("Choose a Color Theme")
                    .multilineTextAlignment(.leading)
                    .font(.title3)
                    .padding(.bottom)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.vertical) {
                Grid (alignment: .topLeading, verticalSpacing: 20){
                    GridRow {
                        ColorThemeView(colorSet: [themeManager.themeSets[0].primaryAccentColor,
                                                  themeManager.themeSets[0].secondaryColor,
                                                  themeManager.themeSets[0].toolbarColor,
                                                  themeManager.themeSets[0].buttonColor,
                                                  themeManager.themeSets[0].bgColor],
                                       label: "Default Theme")
                    }
                    Divider()
                    GridRow {
                        ColorThemeView(colorSet: [themeManager.themeSets[0].primaryAccentColor,
                                                  themeManager.themeSets[0].secondaryColor,
                                                  themeManager.themeSets[0].toolbarColor,
                                                  themeManager.themeSets[0].buttonColor,
                                                  themeManager.themeSets[0].bgColor],
                                       label: "Dark Theme")
                    }
                    Divider()
                    GridRow {
                        ColorThemeView(colorSet: [themeManager.themeSets[0].primaryAccentColor,
                                                  themeManager.themeSets[0].secondaryColor,
                                                  themeManager.themeSets[0].toolbarColor,
                                                  themeManager.themeSets[0].buttonColor,
                                                  themeManager.themeSets[0].bgColor],
                                       label: "Green Theme")
                    }
                    Divider()
                    GridRow {
                        ColorThemeView(colorSet: [themeManager.themeSets[0].primaryAccentColor,
                                                  themeManager.themeSets[0].secondaryColor,
                                                  themeManager.themeSets[0].toolbarColor,
                                                  themeManager.themeSets[0].buttonColor,
                                                  themeManager.themeSets[0].bgColor],
                                       label: "Orange Theme")
                    }
                }
            }
        }
        .frame(minHeight: 360)
        .backgroundStyle(.white)
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(themeManager.currentTheme.secondaryColor, lineWidth: 2)
        )
    }
}

struct ChooseColorThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseColorThemeView()
            .environmentObject(ThemeManager())
    }
}
