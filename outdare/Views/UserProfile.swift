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
            Image(systemName: "ellipsis")
                .resizable()
                .frame(width: 40, height: 8)
                .offset(x: -170, y: -150)
                .foregroundColor(Color.theme.button)
                .rotationEffect(Angle(degrees: 90))
                .onTapGesture {
                    settingsOpened = true
                }
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
                        UserSettings()
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
