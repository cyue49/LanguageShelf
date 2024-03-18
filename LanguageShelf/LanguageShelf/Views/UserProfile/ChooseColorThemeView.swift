import SwiftUI

struct ChooseColorThemeView: View {
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
                        ColorThemeView(colorSet: ["PrimaryAccentColor","IconColor", "ToolBarColor", "ButtonColor", "BackgroundColor"], label: "Default Theme")
                    }
                    Divider()
                    GridRow {
                        ColorThemeView(colorSet: ["PrimaryAccentColor","IconColor", "ToolBarColor", "ButtonColor", "BackgroundColor"], label: "Dark Theme")
                    }
                    Divider()
                    GridRow {
                        ColorThemeView(colorSet: ["PrimaryAccentColor","IconColor", "ToolBarColor", "ButtonColor", "BackgroundColor"], label: "Green Theme")
                    }
                    Divider()
                    GridRow {
                        ColorThemeView(colorSet: ["PrimaryAccentColor","IconColor", "ToolBarColor", "ButtonColor", "BackgroundColor"], label: "Orange Theme")
                    }
                }
            }
        }
        .frame(minHeight: 350)
        .backgroundStyle(.white)
        .cornerRadius(30)
        .overlay(
            RoundedRectangle(cornerRadius: 30)
                .stroke(Color("IconColor"), lineWidth: 2)
        )
    }
}

struct ChooseColorThemeView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseColorThemeView()
    }
}
