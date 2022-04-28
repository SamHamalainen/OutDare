//
//  CardView.swift
//  outdare
//
//  Created by Jasmin Partanen on 5.4.2022.
//
import SwiftUI
import SDWebImageSwiftUI

// List item for leadearboard ranking list
struct RankingListItem: View {
    let users: CurrentUser
    
    var body: some View {
        HStack {
            VStack {
                if users.goneUp == true {
                    Text("1")
                Image(systemName: "arrowtriangle.up.fill")
                    .foregroundColor(Color.theme.rankingUp)
            } else {
                Text("1")
                Image(systemName: "arrowtriangle.down.fill")
                    .foregroundColor(Color.theme.rankingDown)
            }
        }
            .font(Font.customFont.smallText)
            
            VStack {
                if users.profilePicture == "" {
                    Image(systemName: "person.crop.circle.fill")
                        .font(.system(size: 55))
                } else {
                    WebImage(url: URL(string: users.profilePicture))
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipped()
                        .cornerRadius(60)
                }
            }
            .foregroundColor(Color.theme.textDark)
            .padding(.vertical, 10)
            
            Text(users.username)
                .padding(10)
                .font(Font.customFont.normalText)
            Spacer()
            Text("\(users.score)")
                .font(Font.customFont.btnText)
        }
        .padding(2)
    }
}

struct RankingListItem_Previews: PreviewProvider {
    static var users = UserViewModel().usersSorted
    static var previews: some View {
        RankingListItem(users: users[0])
            .previewLayout(.fixed(width: 400, height: 50))
    }
}
