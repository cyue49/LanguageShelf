import SwiftUI

struct ChooseColorThemeView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        GroupBox {
            VStack (alignment: .leading, spacing: 20) {
                Text("Choose a Color Theme")
                    .multilineTextAlignment(.leading)
                    .font(.title3)
                    .foregroundStyle(themeManager.currentTheme.fontColor)
                    .padding(.bottom)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.vertical) {
                Grid (alignment: .topLeading, verticalSpacing: 20){
                    GridRow {
                        Button(action: {
                            themeManager.setTheme(theme: 0)
                            Task {
                                try await userManager.updateUser(attribute: "theme", value: "0")
                            }
                        }, label: {
                            ColorThemeView(colorSet: [themeManager.themeSets[0].primaryAccentColor,
                                                      themeManager.themeSets[0].secondaryColor,
                                                      themeManager.themeSets[0].toolbarColor,
                                                      themeManager.themeSets[0].buttonColor,
                                                      themeManager.themeSets[0].bgColor],
                                           label: "Default Theme")
                        })
                    }
                    Divider()
                    GridRow {
                        Button(action: {
                            themeManager.setTheme(theme: 1)
                            Task {
                                try await userManager.updateUser(attribute: "theme", value: "1")
                            }
                        }, label: {
                            ColorThemeView(colorSet: [themeManager.themeSets[1].primaryAccentColor,
                                                      themeManager.themeSets[1].secondaryColor,
                                                      themeManager.themeSets[1].toolbarColor,
                                                      themeManager.themeSets[1].buttonColor,
                                                      themeManager.themeSets[1].bgColor],
                                           label: "Light Theme")
                        })
                        
                    }
                    Divider()
                    GridRow {
                        Button(action: {
                            themeManager.setTheme(theme: 2)
                            Task {
                                try await userManager.updateUser(attribute: "theme", value: "2")
                            }
                        }, label: {
                            ColorThemeView(colorSet: [themeManager.themeSets[2].primaryAccentColor,
                                                      themeManager.themeSets[2].secondaryColor,
                                                      themeManager.themeSets[2].toolbarColor,
                                                      themeManager.themeSets[2].buttonColor,
                                                      themeManager.themeSets[2].bgColor],
                                           label: "Dark Theme")
                        })
                    }
                    Divider()
                    GridRow {
                        Button(action: {
                            themeManager.setTheme(theme: 3)
                            Task {
                                try await userManager.updateUser(attribute: "theme", value: "3")
                            }
                        }, label: {
                            ColorThemeView(colorSet: [themeManager.themeSets[3].primaryAccentColor,
                                                      themeManager.themeSets[3].secondaryColor,
                                                      themeManager.themeSets[3].toolbarColor,
                                                      themeManager.themeSets[3].buttonColor,
                                                      themeManager.themeSets[3].bgColor],
                                           label: "Green Theme")
                        })
                    }
                }
            }
        }
        .frame(minHeight: 360)
        .backgroundStyle(themeManager.currentTheme.bgColor2)
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
            .environmentObject(UserAccountsManager())
            .environmentObject(ThemeManager())
    }
}
