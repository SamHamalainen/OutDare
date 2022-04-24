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
            SingleProfile(users: vm.secondUser ?? defaultData)
                .offset(x: 25, y: 50)
            SingleProfile(users: vm.firstUser ?? defaultData)
                .zIndex(4)
            SingleProfile(users: vm.thirdUser ?? defaultData)
                .offset(x: -25, y: 50)
        }
        .foregroundColor(Color.theme.textLight)
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
 
