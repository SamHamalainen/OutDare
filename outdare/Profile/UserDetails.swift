//
//  UserDetails.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//

import SwiftUI

struct UserDetails: View {
    var body: some View {
        VStack {
            VStack {
            Image("profile1")
                .resizable()
                .frame(width: 150, height: 150)
                .shadow(radius: 7)
            Text("Username")
                .font(Font.customFont.largeText)
            HStack {
                Image(systemName: "mappin")
                Text("Finland")
                    .font(Font.customFont.smallText)
            }
            .padding(.bottom, 25)
        }
            
            ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.button)
                .frame(width: 120, height: 70)
                .opacity(0.5)
                .shadow(color: Color.theme.textDark, radius: 1, x: 1, y: 1)
                HStack {
            Text("230")
                .font(Font.customFont.extraLargeText)
                .foregroundColor(Color.theme.textLight)
            Image(systemName: "arrowtriangle.down.fill")
                        .foregroundColor(Color.theme.rankingDown)
                }
            }
        }
    }
}

struct UserDetails_Previews: PreviewProvider {
    static var previews: some View {
        UserDetails()
            .previewLayout(.sizeThatFits)
    }
}
