import SwiftUI

// Theme protocol
protocol ThemeProtocol {
    var primaryAccentColor: Color { get }
    var secondaryColor: Color { get }
    var toolbarColor: Color { get }
    var buttonColor: Color { get }
    var bgColor: Color { get }
    var fontColor: Color { get }
}

// Themes

struct DefaultTheme: ThemeProtocol {
    var primaryAccentColor: Color = Color("1-PrimaryAccentColor")
    var secondaryColor: Color = Color("1-SecondaryColor")
    var toolbarColor: Color = Color("1-ToolBarColor")
    var buttonColor: Color = Color("1-ButtonColor")
    var bgColor: Color = Color("1-BackgroundColor")
    var fontColor: Color = Color("1-FontColor")
}
