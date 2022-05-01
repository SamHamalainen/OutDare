//  Profile.swift
//  outdare
//  Created by Jasmin Partanen on 8.4.2022.
//  Description: User profile view

import SwiftUI
import Firebase

struct UserProfile: View {
    @StateObject private var vm = UserViewModel()
    @State var settingsOpened = false
    
    var body: some View {
        ZStack {
            ProfileBackground()
            
            VStack {
                UserDetails()
                    .padding(.top, UIScreen.main.bounds.height * 0.11)
                
                Button (
                    action: {
                        withAnimation(.spring()) {
                            settingsOpened.toggle()
                        }
                    }, label: {
                        Image(systemName: "ellipsis").foregroundColor(.black)
                    }).sheet(isPresented: $settingsOpened, content: {
                        SettingsMenu()
                    })
                    .font(.largeTitle)
                    .rotationEffect(Angle(degrees: 90))
                    .offset(x: UIScreen.main.bounds.width * 0.4, y: -170)
                
                
                VStack {
                    Text("Achievements")
                        .font(Font.customFont.largeText)
                        .frame(width: UIScreen.main.bounds.width * 0.8, alignment: .leading)
                    AchievementList()
                }
                .padding(.top, UIScreen.main.bounds.height * 0.07)
            }
        } .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
}


struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
