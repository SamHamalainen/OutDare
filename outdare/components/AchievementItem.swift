//  AchievementItem.swift
//  outdare
//  Created by Jasmin Partanen on 26.4.2022.
//  Description: Return achievement item
import SwiftUI

struct AchievementItem: View {
    let achievements: Achievement
    @Binding var flippedId: Int
    
    // Choosing correct icon image according to string value from firebase
    func getCategoryIcon() -> Image {
        switch achievements.category {
        case "quiz":
            return Image("quiz")
        case "lyrics":
            return Image("lyrics")
        case "twister":
            return Image("tongueTwister")
        case "stringGame":
            return Image("stringGame")
        default:
            return Image("crown")
        }
    }
    
    
    var body: some View {
        if achievements.id != flippedId {
            getCategoryIcon()
                .resizable()
                .frame(width: 50, height: 50)
        } else {
            Text("\(achievements.score)")
                .font(Font.customFont.extraLargeText)
                .frame(width: 50, height: 50)
        }
        
    }
}

struct AchievementItem_Previews: PreviewProvider {
    static var achievements = UserViewModel().achievementsWithCategory
    static var previews: some View {
        AchievementItem(achievements: achievements[0], flippedId: .constant(5))
    }
}
