//
//  TopRanking.swift
//  outdare
//
//  Created by Jasmin Partanen on 6.4.2022.
//

import SwiftUI


struct TopRanking: View {
    var users: User
    var body: some View {
        VStack {
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

struct TopRanking_Previews: PreviewProvider {
    static var users = LeaderboardModel().sorted[0]
    static var previews: some View {
        TopRanking(users: users)
            .previewLayout(.fixed(width: 400, height: 270))
    }
}
