//  SingleProfile.swift
//  outdare
//  Created by Jasmin Partanen on 8.4.2022.
//  Description: Single user in the leaderboard top ranked profiles

import SwiftUI
import SDWebImageSwiftUI

struct SingleProfile: View {
    var users: CurrentUser
    
    var body: some View {
        VStack {
            VStack {
                if users.profilePicture == "" {
                    Image(systemName: "person.fill")
                        .font(.system(size: UIScreen.main.bounds.width * 0.23))
                        .padding()
                } else {
                    WebImage(url: URL(string: users.profilePicture))
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.32, height: UIScreen.main.bounds.width * 0.32)
                        .clipped()
                        .cornerRadius(UIScreen.main.bounds.width * 0.32)
                }
            }
            .overlay(RoundedRectangle(cornerRadius: UIScreen.main.bounds.width * 0.32)
                .stroke(Color.theme.stroke, lineWidth: 4))
            .foregroundColor(Color.theme.textDark)
            .shadow(color: Color.theme.button, radius: 4, x: 4, y: 4)
            
            Text(users.username)
                .foregroundColor(Color.theme.textLight)
                .font(Font.customFont.normalText)
                .padding(.top, UIScreen.main.bounds.height * 0.01)
            Text("\(users.score)")
                .foregroundColor(Color.theme.stroke)
                .font(Font.customFont.largeText)
        }
    }
}

struct SingleProfile_Previews: PreviewProvider {
    static var users = UserViewModel().usersSorted
    static var previews: some View {
        SingleProfile(users: users[0])
            .previewLayout(.sizeThatFits)
    }
}
