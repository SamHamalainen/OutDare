//
//  TopRanking.swift
//  outdare
//
//  Created by Jasmin Partanen on 6.4.2022.
//
import SwiftUI


struct TopProfiles: View {
    @StateObject private var vm = UserViewModel()
    let defaultData = CurrentUser(id: "", username: "Username", location: "Location not set", email: "email not set", profilePicture: "", score: 0)

    
    var body: some View {
        HStack {
            if vm.usersSorted.indices.contains(1) {
                VStack {
                Text("2.")
                    SingleProfile(users: vm.usersSorted[1])
                }
                .offset(x: UIScreen.main.bounds.width * 0.05, y: UIScreen.main.bounds.height * 0.07)
            }
            
            if vm.usersSorted.indices.contains(0) {
                VStack {
                Image("crown")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width * 0.2, height: UIScreen.main.bounds.width * 0.15)
                    SingleProfile(users: vm.usersSorted[0])
                }
                .zIndex(4)
            }
            if vm.usersSorted.indices.contains(2) {
                VStack {
                Text("3.")
                    SingleProfile(users: vm.usersSorted[2])
                }
                    .offset(x: -UIScreen.main.bounds.width * 0.05, y: UIScreen.main.bounds.height * 0.07)
            }
        }
        .foregroundColor(Color.theme.textLight)
        .font(Font.customFont.largeText)
    }
}

struct TopProfiles_Previews: PreviewProvider {
    static var users = UserViewModel()
    static var previews: some View {
        TopProfiles()
            .environmentObject(UserViewModel())
            .previewLayout(.sizeThatFits)
    }
}
 
