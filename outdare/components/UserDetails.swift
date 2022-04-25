//
//  UserDetails.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//
import SwiftUI
import SDWebImageSwiftUI

struct UserDetails: View {
    @ObservedObject private var vm = UserViewModel()
    
    var body: some View {
        VStack {
            VStack {
                VStack {
                    if vm.currentUser?.profilePicture == "" {
                        Image(systemName: "person.fill")
                            .font(.system(size: 120))
                            .padding()
                    } else {
                        WebImage(url: URL(string: vm.currentUser?.profilePicture ?? ""))
                            .resizable()
                            .frame(width: 170, height: 170)
                            .clipped()
                            .cornerRadius(170)
                    }
                }
                    .overlay(RoundedRectangle(cornerRadius: 170)
                        .stroke(Color.theme.stroke, lineWidth: 4))
                
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
