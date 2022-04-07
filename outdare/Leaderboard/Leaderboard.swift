//
//  Leaderboard.swift
//  outdare
//
//  Created by Jasmin Partanen on 4.4.2022.
//

import SwiftUI

struct Leaderboard: View {
    let users: [User]
    var body: some View {
        ZStack() {
            Trapezium()
            VStack {
                HStack {
                    VStack {
                    Text("2")
                    TopRanking(users: users[1])
                    }
                    .offset(x: 20, y: 60)
                    .foregroundColor(Color.theme.textLight)
                    VStack {
                    Text("1")
                            .foregroundColor(Color.theme.textLight)
                    Image("crown")
                            .resizable()
                            .frame(width: 50, height: 45)
                    TopRanking(users: users[0])
                        .zIndex(10)
                    }
                    VStack {
                        Text("3")
                        TopRanking(users: users[2])
                    }
                    .offset(x: -20, y: 60)
                    .foregroundColor(Color.theme.textLight)
                }
                .font(Font.customFont.btnText)
                
            ScrollView {
                ForEach(users.dropFirst(3)) { user in
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
            .frame(height: 380)
            .offset(y: 80)
            }
        }
    }
}

struct Leaderboard_Previews: PreviewProvider {
    static var previews: some View {
        Leaderboard(users: LeaderboardModel().sorted)
    }
}
