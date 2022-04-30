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
                    .padding(.bottom, UIScreen.main.bounds.height * 0.03)
                LeaderboardList()
                    .frame(height: UIScreen.main.bounds.height * 0.44)
                    .offset(y: UIScreen.main.bounds.height * 0.11)
                    .padding(.bottom, UIScreen.main.bounds.height * 0.046)
            }
                LottieView(lottieFile: "arrows")
                    .frame(width: 120, height: 120)
                    .offset(y: UIScreen.main.bounds.height * 0.4)
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}
struct Leaderboard_Previews: PreviewProvider {
    static var previews: some View {
        Leaderboard()
            .environmentObject(UserViewModel())
    }
}
