import SwiftUI

class ThemeManager: ObservableObject {
    @Published var currentTheme: ThemeProtocol = DefaultTheme()
    var themeSets: [ThemeProtocol] = [DefaultTheme(), DarkTheme(), GreenTheme(), LightTheme()]
    
    func setTheme(theme: Int) {
        currentTheme = themeSets[theme]
    }
}
