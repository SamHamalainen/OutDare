//
//  SettingsMenu.swift
//  outdare
//
//  Created by Jasmin Partanen on 26.4.2022.
//

import SwiftUI

struct SettingsMenu: View {
    @ObservedObject private var vm = UserViewModel()
    @State var changeCredentials = false
    @State var changeInformationOpen = false
    
    var body: some View {
        ZStack (alignment: .top) {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.theme.background2)
                .frame(height: 640)
            VStack(alignment: .leading) {
            Section {
                Button (
                    action: {
                        withAnimation(.spring()) {
                            changeCredentials.toggle()
                        }
                    }, label: {
                            Text("Change credentials")
                            Spacer()
                            Image(systemName: "wallet.pass.fill").foregroundColor(.white)
                    })
                .padding(.top, 40)
                Text("Password and email used for login")
                    .font(Font.customFont.smallText)
                    .offset(y: -20)
                
                Button (
                    action: {
                        withAnimation(.spring()) {
                            changeInformationOpen.toggle()
                        }
                    }, label: {
                            Text("Change user information")
                            Spacer()
                            Image(systemName: "info").foregroundColor(.white)
                    })
                Text("Username and location")
                    .font(Font.customFont.smallText)
                    .offset(y: -20)
                }
            .font(Font.customFont.largeText)
            .foregroundColor(Color.theme.textDark)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            }
        }
        
        if changeCredentials {
            ZStack(alignment: .bottom) {
            Rectangle()
                .ignoresSafeArea()
                .opacity(0.45)
                .onTapGesture {
                    changeCredentials = false
                }
                ChangeCredentials(oldEmail: vm.currentUser?.email ?? "")
                }
            .edgesIgnoringSafeArea(.bottom)
        }
        
        if changeInformationOpen {
            ZStack(alignment: .bottom) {
            Rectangle()
                .ignoresSafeArea()
                .opacity(0.45)
                .onTapGesture {
                    changeInformationOpen = false
                }
                ChangeInformation(username: vm.currentUser?.username ?? "", location: vm.currentUser?.location ?? "")
                }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct SettingsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu()
    }
}
