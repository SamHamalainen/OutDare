//
//  TopRanking.swift
//  outdare
//
//  Created by Jasmin Partanen on 6.4.2022.
//

import SwiftUI


struct TopProfiles: View {
    @EnvironmentObject var userData: LeaderboardModel
    
    var body: some View {
        HStack {
        SingleProfile(users: userData.sorted[1])
                .offset(x: 25, y: 50)
        SingleProfile(users: userData.sorted[0])
                .zIndex(4)
        SingleProfile(users: userData.sorted[2])
                .offset(x: -25, y: 50)
        }
        .foregroundColor(Color.theme.textLight)
    }
}

struct TopProfiles_Previews: PreviewProvider {
    static var users = LeaderboardModel().sorted[0]
    static var previews: some View {
        TopProfiles()
            .environmentObject(LeaderboardModel())
            .previewLayout(.sizeThatFits)
    }
}
 
