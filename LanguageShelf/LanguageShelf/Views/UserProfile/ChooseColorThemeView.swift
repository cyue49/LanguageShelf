import SwiftUI

struct ChooseColorThemeView: View {
    @EnvironmentObject var userManager: UserAccountsManager
    
    var body: some View {
        GroupBox {
            VStack (alignment: .leading, spacing: 20) {
                Text("Choose a Color Theme")
                    .multilineTextAlignment(.leading)
                    .font(.title3)
                    .foregroundStyle(userManager.currentTheme.fontColor)
                    .padding(.bottom)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.vertical) {
                Grid (alignment: .topLeading, verticalSpacing: 20){
                    GridRow {
                        Button(action: {
                            userManager.setTheme(theme: 0)
                            Task {
                                try await userManager.updateUser(attribute: "theme", value: "0")
                            }
                        }, label: {
                            ColorThemeView(colorSet: [userManager.themeSets[0].primaryAccentColor,
                                                      userManager.themeSets[0].secondaryColor,
                                                      userManager.themeSets[0].toolbarColor,
                                                      userManager.themeSets[0].buttonColor,
                                                      userManager.themeSets[0].bgColor],
                                           label: "Default Theme")
                        })
                    }
                    Divider()
                    GridRow {
                        Button(action: {
                            userManager.setTheme(theme: 1)
                            Task {
                                try await userManager.updateUser(attribute: "theme", value: "1")
                            }
                        }, label: {
                            ColorThemeView(colorSet: [userManager.themeSets[1].primaryAccentColor,
                                                      userManager.themeSets[1].secondaryColor,
                                                      userManager.themeSets[1].toolbarColor,
                                                      userManager.themeSets[1].buttonColor,
                                                      userManager.themeSets[1].bgColor],
                                           label: "Light Theme")
                        })
                        
                    }
                    Divider()
                    GridRow {
                        Button(action: {
                            userManager.setTheme(theme: 2)
                            Task {
                                try await userManager.updateUser(attribute: "theme", value: "2")
                            }
                        }, label: {
                            ColorThemeView(colorSet: [userManager.themeSets[2].primaryAccentColor,
                                                      userManager.themeSets[2].secondaryColor,
                                                      userManager.themeSets[2].toolbarColor,
                                                      userManager.themeSets[2].buttonColor,
                                                      userManager.themeSets[2].bgColor],
                                           label: "Dark Theme")
                        })
                    }
                    Divider()
                    GridRow {
                        Button(action: {
                            userManager.setTheme(theme: 3)
                            Task {
                                try await userManager.updateUser(attribute: "theme", value: "3")
                            }
                        }, label: {
                            ColorThemeView(colorSet: [userManager.themeSets[3].primaryAccentColor,
                                                      userManager.themeSets[3].secondaryColor,
                                                      userManager.themeSets[3].toolbarColor,
                                                      userManager.themeSets[3].buttonColor,
                                                      userManager.themeSets[3].bgColor],
                                           label: "Green Theme")
                        })
                    }
                }
            }
        }
        .frame(minHeight: 360)
        .backgroundStyle(userManager.currentTheme.bgColor2)
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(userManager.currentTheme.secondaryColor, lineWidth: 2)
        )
    }
}

struct ChooseColorThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseColorThemeView()
            .environmentObject(UserAccountsManager())
    }
}
