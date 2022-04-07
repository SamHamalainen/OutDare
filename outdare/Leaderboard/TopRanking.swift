//
//  TopRanking.swift
//  outdare
//
//  Created by Jasmin Partanen on 6.4.2022.
//

import SwiftUI

struct TopRanking: View {
    var users: LeaderboardCard
    var body: some View {
        HStack {
            Image("profile2")
            Image("profile1")
            Image("profile3")
        }
    }
}

struct TopRanking_Previews: PreviewProvider {
    static var users = LeaderboardCard.userData[0]
    static var previews: some View {
        TopRanking(users: users)
            .previewLayout(.fixed(width: 400, height: 270))
    }
}
