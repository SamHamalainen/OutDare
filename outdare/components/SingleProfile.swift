//
//  SingleProfile.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//
import SwiftUI
import SDWebImageSwiftUI

struct SingleProfile: View {
    var users: CurrentUser
    
    var body: some View {
        VStack {
            VStack {
                if users.profilePicture == "" {
                    Image(systemName: "person.fill")
                        .font(.system(size: 80))
                        .padding()
                } else {
                    WebImage(url: URL(string: users.profilePicture))
                        .resizable()
                        .frame(width: 120, height: 120)
                        .clipped()
                        .cornerRadius(100)
                }
            }
            .overlay(RoundedRectangle(cornerRadius: 80)
                .stroke(Color.theme.stroke, lineWidth: 4))
            .foregroundColor(Color.theme.textDark)
            
                Text(users.username)
                    .foregroundColor(Color.theme.textLight)
                    .font(Font.customFont.normalText)
                Text("\(users.score)")
                    .foregroundColor(Color.theme.stroke)
                    .font(Font.customFont.largeText)
        }
    }
}

struct SingleProfile_Previews: PreviewProvider {
    static var users = UserViewModel().usersSorted
    static var previews: some View {
        SingleProfile(users: users[0])
            .previewLayout(.sizeThatFits)
    }
}
