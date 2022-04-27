//
//  SingleProfile.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//
import SwiftUI
import SDWebImageSwiftUI

struct SingleProfile: View {
    var users: CurrentUser
    
    var body: some View {
        VStack {
//            VStack {
//                if users.goneUp == true {
//                Text("1")
//                        .font(Font.customFont.largeText)
//                Image(systemName: "arrowtriangle.up.fill")
//                    .foregroundColor(Color.theme.rankingUp)
//            } else {
//                Text("1")
//                    .font(Font.customFont.largeText)
//                Image(systemName: "arrowtriangle.down.fill")
//                    .foregroundColor(Color.theme.rankingDown)
//            }
//        }
//            .padding(2)
            VStack {
                if users.profilePicture == "" {
                    Image(systemName: "person.fill")
                        .font(.system(size: 80))
                        .padding()
                } else {
                    WebImage(url: URL(string: users.profilePicture))
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipped()
                        .cornerRadius(100)
                }
            }
            .overlay(RoundedRectangle(cornerRadius: 80)
                .stroke(Color.theme.stroke, lineWidth: 4))
            .foregroundColor(Color.theme.textDark)
            
                Text(users.username)
                    .foregroundColor(Color.theme.textLight)
                    .font(Font.customFont.normalText)
                Text("\(users.score)")
                    .foregroundColor(Color.theme.stroke)
                    .font(Font.customFont.largeText)
        }
    }
}

struct SingleProfile_Previews: PreviewProvider {
    static var users = UserViewModel().firstUser
    static var previews: some View {
        SingleProfile(users: users ?? CurrentUser(id: 2, username: "Username", location: "Location not set", email: "email not set", profilePicture: "", score: 0, goneUp: false))
            .previewLayout(.sizeThatFits)
    }
}
