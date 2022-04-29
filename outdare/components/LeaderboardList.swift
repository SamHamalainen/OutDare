//
//  LeaderboardList.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//
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
                        .padding(.horizontal, 15)
            }
        }
            .padding(15)
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
