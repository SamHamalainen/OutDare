//
//  SettingsItem.swift
//  outdare
//
//  Created by Jasmin Partanen on 14.4.2022.
//
import SwiftUI


// Single item for settings
struct SettingsItem: View {
    @State var placeholder: String
    @State var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
                .frame(width: 270, height: 60)
                .padding(.horizontal, 8)
                .background(Color.theme.transparent)
                .cornerRadius(15)
    }
}
struct SettingsItem_Previews: PreviewProvider {
    static var previews: some View {
        SettingsItem(placeholder: "Password", text: "New password")
            .previewLayout(.sizeThatFits)
    }
}
