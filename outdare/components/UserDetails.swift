//
//  UserDetails.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//
import SwiftUI

struct UserDetails: View {
    @ObservedObject private var vm = UserViewModel()
    
    var body: some View {
        VStack {
            VStack {
            Image("profile1")
                .resizable()
                .frame(width: 150, height: 150)
                .shadow(radius: 7)
                
                Text(vm.currentUser?.username ?? "")
                .font(Font.customFont.largeText)
                
            HStack {
                Image(systemName: "mappin")
                Text(vm.currentUser?.location ?? "")
                    .font(Font.customFont.smallText)
            }
            .padding(.vertical, 2)
        }
            
            ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.button)
                .frame(width: 120, height: 70)
                .opacity(0.5)
                .shadow(color: Color.theme.textDark, radius: 1, x: 1, y: 1)
                HStack {
                    Text("\(vm.currentUser?.score ?? 0)")
                .font(Font.customFont.extraLargeText)
                .foregroundColor(Color.theme.textLight)
                GetCurrentUserPrevRanking()
                }
            }
        }
    }
}

struct UserDetails_Previews: PreviewProvider {
    static var previews: some View {
        UserDetails()
            .previewLayout(.sizeThatFits)
    }
}
