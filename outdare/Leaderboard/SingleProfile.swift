//
//  SingleProfile.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//

import SwiftUI

struct SingleProfile: View {
    var users: User
    
    var body: some View {
        VStack {
            VStack {
                if users.goneUp == true {
                Text("1")
                Image(systemName: "arrowtriangle.up.fill")
                    .foregroundColor(Color.theme.rankingUp)
            } else {
                Text("1")
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
    static var users = LeaderboardModel().sorted
    static var previews: some View {
        SingleProfile(users: users[0])
            .previewLayout(.sizeThatFits)
    }
}
