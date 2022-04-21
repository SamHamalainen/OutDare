//
//  LeaderboardList.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//
import SwiftUI

struct LeaderboardList: View {
    @ObservedObject private var vm = UserViewModel()
    
    var body: some View {
        ScrollView {
            ForEach(vm.users.dropFirst(3)) { user in
                ZStack {
                RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.theme.transparent)
                        .shadow(color: Color.theme.icon, radius: 2, x: 2, y: 3)
                    RankingListItem(users: user)
                        .padding(.horizontal, 15)
            }
        }
            .padding(15)
        }
    }
}

// leaderboardModel.sorted.dropFirst(3)
struct LeaderboardList_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardList()
            .environmentObject(UserViewModel())
            .previewLayout(.sizeThatFits)
    }
}
