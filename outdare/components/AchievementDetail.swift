//
//  AchievementDetail.swift
//  outdare
//
//  Created by Sam Hämäläinen on 2.5.2022.
//

import SwiftUI

struct AchievementDetail: View {
    @StateObject var dao = ChallengeDAO()
    let achievement: Achievement
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: .infinity)
                        .foregroundColor(Color.theme.textLight)
                        .shadow(color: Color.theme.icon, radius: 2, x: 2, y: 3)
                        .frame(width: 80, height: 80)
                    Image(achievement.category)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding(.horizontal, 15)
                }
                if let challenge = dao.challenge {
                    VStack (alignment: .leading) {
                        Text(challenge.name)
                            .font(Font.customFont.largeText)
                        Text(LocalizedStringKey(challenge.difficulty.rawValue.capitalized))
                            .foregroundColor(getDifficultyColor(challengeDifficulty: challenge.difficulty))
                            .font(Font.customFont.normalText)
                    }
                }
                Spacer()
                Text(String(achievement.score))
                    .font(Font.customFont.largeText)
                    .padding()
                    .background(Color("Background"))
                    .cornerRadius(.infinity)
                    .foregroundColor(.white)
            }
            .onAppear {
                dao.getChallenge(id: achievement.challengeId)
            }
            .padding()
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: .infinity, alignment: .top)
            .background(Color("Background2"))
        }
    }
}

struct AchievementDetail_Previews: PreviewProvider {
    static var previews: some View {
        AchievementDetail(achievement: Achievement(id: 1, challengeId: 1, score: 24, time: 13, userId: "hfoidfads", speedBonus: true, category: "lyrics", difficulty: "Hard"))
    }
}
