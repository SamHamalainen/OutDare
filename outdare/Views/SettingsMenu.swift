//  SettingsMenu.swift
//  outdare
//  Created by Jasmin Partanen on 26.4.2022.
//  Description: Showing menu for changeCredentials and changeInformation
import SwiftUI

struct SettingsMenu: View {
    @StateObject private var vm = UserViewModel()
    @State var changeCredentials = false
    @State var changeInformationOpen = false
    
    var body: some View {
        ZStack (alignment: .top) {
            Color.theme.background2
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 120, height: 5)
                .padding()
                .foregroundColor(Color.theme.button)
            
            VStack(alignment: .leading) {
                Section {
                    Button (
                        action: {
                            withAnimation(.spring()) {
                                changeCredentials = true
                            }
                        }, label: {
                            Text("Credentials")
                            Spacer()
                            Image(systemName: "wallet.pass.fill").foregroundColor(.white)
                        }).sheet(isPresented: $changeCredentials, content: {
                            
                            // Passing logged in user email to changeCredentials view as default value
                            ChangeCredentials(oldEmail: vm.currentUser?.email ?? "")
                        })
                        .padding(.top, 60)
                    Text("Password and email used for login")
                        .font(Font.customFont.smallText)
                        .offset(y: -20)
                    
                    Section {
                        Button (
                            action: {
                                withAnimation(.spring()) {
                                    changeInformationOpen.toggle()
                                }
                            }, label: {
                                Text("User information")
                                Spacer()
                                Image(systemName: "info").foregroundColor(.white)
                            }).sheet(isPresented: $changeInformationOpen, content: {
                                
                                // Passing logged in username and location to changeInformation view as default value
                                ChangeInformation(username: vm.currentUser?.username ?? "", location: vm.currentUser?.location ?? "")
                            })
                        Text("Username and location")
                            .font(Font.customFont.smallText)
                            .offset(y: -20)
                    }
                }
                .font(Font.customFont.largeText)
                .foregroundColor(Color.theme.textDark)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            }
        } .ignoresSafeArea(edges: .bottom)
    }
}

struct SettingsMenu_Previews: PreviewProvider {
    static var previews: some View {
        SettingsMenu()
    }
}
