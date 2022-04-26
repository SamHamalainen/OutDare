//
//  Profile.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//
import SwiftUI
import Firebase

struct UserProfile: View {
    @ObservedObject private var vm = UserViewModel()
    @State var settingsOpened = false
    
    
    var body: some View {
        ZStack {
            ProfileBackground()
            UserDetails()
                .offset(y: -170)
            
            Button (
                action: {
                    withAnimation(.spring()) {
                        settingsOpened.toggle()
                    }
                }, label: {
                    if !settingsOpened {
                        Image(systemName: "ellipsis").foregroundColor(.white)
                    } else {
                        Image(systemName: "ellipsis").foregroundColor(.black)
                    }
                })
            .font(.largeTitle)
            .offset(x: -170, y: -150)
            .rotationEffect(Angle(degrees: 90))
            
                Text("Achievements")
                    .font(Font.customFont.largeText)
                    .frame(maxWidth: 320, maxHeight: 220, alignment: .bottomLeading)
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


struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
