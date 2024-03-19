import SwiftUI

// Theme protocol
protocol ThemeProtocol {
    var primaryAccentColor: Color { get }
    var secondaryColor: Color { get }
    var toolbarColor: Color { get }
    var buttonColor: Color { get }
    var bgColor: Color { get }
    var bgColor2: Color { get }
    var fontColor: Color { get }
}

// Themes

struct DefaultTheme: ThemeProtocol {
    var primaryAccentColor: Color = Color("1-PrimaryAccentColor")
    var secondaryColor: Color = Color("1-SecondaryColor")
    var toolbarColor: Color = Color("1-ToolbarColor")
    var buttonColor: Color = Color("1-ButtonColor")
    var bgColor: Color = Color("1-BackgroundColor")
    var bgColor2: Color = Color("1-BackgroundColor2")
    var fontColor: Color = Color("1-FontColor")
}

struct DarkTheme: ThemeProtocol {
    var primaryAccentColor: Color = Color("2-PrimaryAccentColor")
    var secondaryColor: Color = Color("2-SecondaryColor")
    var toolbarColor: Color = Color("2-ToolbarColor")
    var buttonColor: Color = Color("2-ButtonColor")
    var bgColor: Color = Color("2-BackgroundColor")
    var bgColor2: Color = Color("2-BackgroundColor2")
    var fontColor: Color = Color("2-FontColor")
}

struct GreenTheme: ThemeProtocol {
    var primaryAccentColor: Color = Color("3-PrimaryAccentColor")
    var secondaryColor: Color = Color("3-SecondaryColor")
    var toolbarColor: Color = Color("3-ToolbarColor")
    var buttonColor: Color = Color("3-ButtonColor")
    var bgColor: Color = Color("3-BackgroundColor")
    var bgColor2: Color = Color("3-BackgroundColor2")
    var fontColor: Color = Color("3-FontColor")
}

struct LightTheme: ThemeProtocol {
    var primaryAccentColor: Color = Color("4-PrimaryAccentColor")
    var secondaryColor: Color = Color("4-SecondaryColor")
    var toolbarColor: Color = Color("4-ToolbarColor")
    var buttonColor: Color = Color("4-ButtonColor")
    var bgColor: Color = Color("4-BackgroundColor")
    var bgColor2: Color = Color("4-BackgroundColor2")
    var fontColor: Color = Color("4-FontColor")
}
