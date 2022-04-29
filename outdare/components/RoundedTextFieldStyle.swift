//
//  RoundedTextFieldStyle.swift
//  outdare
//
//  Created by iosdev on 9.4.2022.
//
import SwiftUI

struct RoundedTextFieldStyle: TextFieldStyle {
    var alignment: TextAlignment = .center
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(15)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .gray, radius: 1, x: 0, y: 3)
            .multilineTextAlignment(alignment)
            .font(Font.customFont.normalText)
    }
}
