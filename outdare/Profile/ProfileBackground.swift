//
//  ProfileBackground.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//

import SwiftUI

struct ProfileBackground: View {
    var body: some View {
        ZStack {
        Color.theme.background2
        RoundedRectangle(cornerRadius: 0)
            .fill(Color.theme.background)
            .frame(height: 250)
            .offset(y: -340)
            .shadow(color: Color.theme.textDark, radius: 5, x: 0, y: 1)
            
        RoundedRectangle(cornerRadius: 0)
                .fill(Color.theme.background)
                .frame(height: 5)
                .offset(y: 50)
        }
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct ProfileBackground_Previews: PreviewProvider {
    static var previews: some View {
        ProfileBackground()
    }
}
