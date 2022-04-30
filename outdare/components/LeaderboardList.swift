//
//  LeaderboardList.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//  Description: List component for iterating through the users in leaderboard list

import SwiftUI

struct LeaderboardList: View {
    @StateObject private var vm = UserViewModel()
    
    var body: some View {
        ScrollView {
            ForEach(vm.rankingSorted.dropFirst(3)) { rankingItem in
                ZStack {
                RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.theme.transparent)
                        .shadow(color: Color.theme.icon, radius: 2, x: 2, y: 3)
                    RankingListItem(item: rankingItem)
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.04)
            }
        }
            .padding(UIScreen.main.bounds.width * 0.04)
        }
    }
}

struct LeaderboardList_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardList()
            .environmentObject(UserViewModel())
            .previewLayout(.sizeThatFits)
    }
}
