//
//  AchievementItem.swift
//  outdare
//
//  Created by Jasmin Partanen on 26.4.2022.
//

import SwiftUI

struct AchievementItem: View {
    let achievements: Achievement
    
    func getCategoryIcon() -> Image {
        switch achievements.category {
        case "quiz":
            return Image("quiz")
        case "lyrics":
            return Image("lyrics")
        case "twister":
            return Image("tongueTwister")
        case "stringGame":
            return Image("tongueTwister")
        default:
            return Image("crown")
        }
    }

    
    var body: some View {
        HStack {
            getCategoryIcon()
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
}

struct AchievementItem_Previews: PreviewProvider {
    static var achievements = UserViewModel().achievementsWithCategory
    static var previews: some View {
        AchievementItem(achievements: achievements[0])
    }
}
