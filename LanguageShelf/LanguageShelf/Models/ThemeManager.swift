import SwiftUI

class ThemeManager: ObservableObject {
    @Published var currentTheme: ThemeProtocol = DefaultTheme()
    var themeSets: [ThemeProtocol] = [DefaultTheme()]
    
    func setTheme(theme: ThemeProtocol) {
        currentTheme = theme 
    }
}
