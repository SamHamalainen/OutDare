//
//  SingleProfile.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//
import SwiftUI

struct SingleProfile: View {
    var users: CurrentUser
    
    var body: some View {
        VStack {
            VStack {
                if users.goneUp == true {
                Text("1")
                        .font(Font.customFont.largeText)
                Image(systemName: "arrowtriangle.up.fill")
                    .foregroundColor(Color.theme.rankingUp)
            } else {
                Text("1")
                    .font(Font.customFont.largeText)
                Image(systemName: "arrowtriangle.down.fill")
                    .foregroundColor(Color.theme.rankingDown)
            }
        }
            .padding(2)
                CircleImage(image: Image("profile1"))
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
