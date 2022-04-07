//
//  Leaderboard.swift
//  outdare
//
//  Created by Jasmin Partanen on 4.4.2022.
//

import SwiftUI

struct Leaderboard: View {
    let users: [LeaderboardCard]
    var body: some View {
        ZStack() {
            Trapezium()
            VStack {
            ScrollView {
                ForEach(users) { user in
                    ZStack {
                    RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.theme.transparent)
                            .shadow(color: Color.theme.icon, radius: 2, x: 0, y: 4)
                    RankingListItem(users: user)
                            .padding(.horizontal, 15)
                }
            }
                .padding(15)
        }
            .frame(height: 310)
            .offset(y: 170)
            }
        }
    }
}

struct Leaderboard_Previews: PreviewProvider {
    static var previews: some View {
        Leaderboard(users: LeaderboardCard.userData)
    }
}
