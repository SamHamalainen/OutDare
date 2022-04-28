//
//  Profile.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//
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
                    .padding(.top, 30)
            
            Button (
                action: {
                    withAnimation(.spring()) {
                        settingsOpened.toggle()
                    }
                }, label: {
                        Image(systemName: "ellipsis").foregroundColor(.black)
                })
                    .font(.largeTitle)
                    .rotationEffect(Angle(degrees: 90))
                    .offset(x: 150, y: -170)
                
                Text("Achievements")
                    .font(Font.customFont.largeText)
                    .frame(width: 350, alignment: .leading)
                    .padding(.top, 60)
            AchievementList()
        }
            
            if settingsOpened {
                ZStack(alignment: .bottom) {
                Rectangle()
                    .ignoresSafeArea()
                    .opacity(0.45)
                    .onTapGesture {
                        settingsOpened = false
                    }
                    SettingsMenu()
                    }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}


struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
