//  CardView.swift
//  outdare
//  Created by Jasmin Partanen on 5.4.2022.
//  Description: Single user on the leaderboard ranking list

import SwiftUI
import SDWebImageSwiftUI

struct RankingListItem: View {
    let item: RankingItem
    
    var body: some View {
        HStack {
            Text("\(item.rank).")
                .font(Font.customFont.normalText)
            
            VStack {
                if item.user.profilePicture == "" {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 55))
                } else {
                    WebImage(url: URL(string: item.user.profilePicture))
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(60)
                }
            }
            .foregroundColor(Color.theme.textDark)
            .padding(.vertical, 10)
            
            Text(item.user.username)
                .padding(10)
                .font(Font.customFont.normalText)
            Spacer()
            Text("\(item.user.score)")
                .font(Font.customFont.btnText)
        }
        .padding(2)
    }
}

struct RankingListItem_Previews: PreviewProvider {
    static var defaultData = CurrentUser(id: "", username: "Username", location: "Location not set", email: "email not set", profilePicture: "", score: 0)
    static var users = UserViewModel().usersSorted
    static var previews: some View {
        RankingListItem(item: RankingItem(1, defaultData))
            .previewLayout(.sizeThatFits)
    }
}
