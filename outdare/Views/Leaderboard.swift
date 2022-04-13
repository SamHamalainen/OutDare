//
//  Leaderboard.swift
//  outdare
//
//  Created by Jasmin Partanen on 4.4.2022.
//

import SwiftUI

struct Leaderboard: View {

    var body: some View {
        ZStack() {
            Trapezium()
            VStack {
                TopProfiles()
                    .padding(.bottom, 60)
                LeaderboardList()
                    .frame(height: 370)
                    .offset(y: 50)
                    
            }
            Image(systemName: "arrowtriangle.down.fill")
                .resizable()
                .frame(width: 30, height: 15)
                .foregroundColor(Color.theme.textLight)
                .offset(y: 360)
                .shadow(color: Color.theme.textDark, radius: 10, x: 2, y: 4)
        }
    }
}
struct Leaderboard_Previews: PreviewProvider {
    static var previews: some View {
        Leaderboard()
            .environmentObject(LeaderboardModel())
    }
}
