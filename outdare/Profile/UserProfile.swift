//
//  Profile.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//

import SwiftUI

struct UserProfile: View {
    var body: some View {
        ZStack {
            ProfileBackground()
            UserDetails()
                .offset(y: -140)
            Image(systemName: "ellipsis")
                .resizable()
                .frame(width: 40, height: 8)
                .offset(x: -170, y: -150)
                .foregroundColor(Color.theme.button)
                .rotationEffect(Angle(degrees: 90))
            Text("Achievements")
                .offset(x: -80, y: 100)
                .font(Font.customFont.largeText)
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
