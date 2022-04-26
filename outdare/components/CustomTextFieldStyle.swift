//
//  TextFieldStyle.swift
//  outdare
//
//  Created by Jasmin Partanen on 26.4.2022.
//

import SwiftUI

// Custom text field
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(15)
            .background(LinearGradient(gradient: Gradient(colors: [Color.theme.transparent, Color.theme.transparent]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color(red: 236/255, green: 234/255, blue: 235/255),
                            lineWidth: 4)
                    .shadow(color: Color(red: 192/255, green: 189/255, blue: 191/255),
                            radius: 3, x: 5, y: 5)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15)
                    )
                    .shadow(color: Color.white, radius: 2, x: -2, y: -2)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 15)
                    )
            )
            .background(Color(red: 236/255, green: 234/255, blue: 235/255))
            .cornerRadius(20)
    }
}
