//
//  CardView.swift
//  outdare
//
//  Created by Jasmin Partanen on 5.4.2022.
//

import SwiftUI
// List item for leadearboard ranking list
struct RankingListItem: View {
    let users: User
    var body: some View {
        HStack {
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
            .font(Font.customFont.smallText)
            Image("profile1")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(10)
            Text(users.username)
                .padding(10)
                .font(Font.customFont.normalText)
            Spacer()
            Text("\(users.score)")
                .font(Font.customFont.btnText)
        }
        .padding(2)
    }
}

struct RankingListItem_Previews: PreviewProvider {
    static var users = LeaderboardModel().sorted[0]
    static var previews: some View {
        RankingListItem(users: users)
            .previewLayout(.fixed(width: 400, height: 50))
    }
}
