//
//  LeaderboardList.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//

import SwiftUI

struct LeaderboardList: View {
    @EnvironmentObject var userData: LeaderboardModel
    
    var body: some View {
        ScrollView {
            ForEach(userData.sorted.dropFirst(3)) { user in
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
        .frame(height: 420)
        .offset(y: 115)
    }
}

struct LeaderboardList_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardList()
            .environmentObject(LeaderboardModel())
    }
}
