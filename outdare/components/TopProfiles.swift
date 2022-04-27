//
//  TopRanking.swift
//  outdare
//
//  Created by Jasmin Partanen on 6.4.2022.
//
import SwiftUI


struct TopProfiles: View {
    @ObservedObject private var vm = UserViewModel()
    let defaultData = CurrentUser(id: 2, username: "Username", location: "Location not set", email: "email not set", profilePicture: "", score: 0, goneUp: false)
    
    var body: some View {
        HStack {
            
            VStack {
            Text("2.")
            SingleProfile(users: vm.secondUser ?? defaultData)
            }
                .offset(x: 20, y: 65)
            VStack {
            Image("crown")
                    .resizable()
                    .frame(width: 70, height: 50)
            SingleProfile(users: vm.firstUser ?? defaultData)
            }
            .zIndex(4)
            
            VStack {
            Text("3.")
            SingleProfile(users: vm.thirdUser ?? defaultData)
            }
                .offset(x: -20, y: 65)
        }
        .foregroundColor(Color.theme.textLight)
        .font(Font.customFont.largeText)
    }
}

struct TopProfiles_Previews: PreviewProvider {
    static var users = UserViewModel().firstUser
    static var previews: some View {
        TopProfiles()
            .environmentObject(UserViewModel())
            .previewLayout(.sizeThatFits)
    }
}
 
