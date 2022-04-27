//
//  MainView.swift
//  outdare
//
//  Created by Tatu Ihaksi on 6.4.2022.
//

import SwiftUI

struct MainView: View {
    @State private var isShowingMenu = false
    @State private var currentTitle = "Map"
    @State private var currentView: AnyView = AnyView(MapView())
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                
                // View that displays the selected view
                ZStack {
                    Color(.white)
                    currentView
                }
                .ignoresSafeArea(edges: .bottom)
                    .onTapGesture {
                        if (isShowingMenu) {
                            isShowingMenu = false
                        }
                    }
                    .navigationBarTitleDisplayMode(.inline).toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(
                                action: {
                                    withAnimation(.spring()) {
                                        isShowingMenu.toggle()
                                    }
                                }, label: {
                                    if !isShowingMenu {
                                        Image(systemName: "list.bullet").foregroundColor(.white)
                                    } else {
                                        Image(systemName: "list.bullet").foregroundColor(.black)
                                    }
                                })
                        }
                        ToolbarItem(placement: .principal) {
                            if(!isShowingMenu && currentTitle != "Store") {
                                Text(currentTitle)
                                    .font(Font.customFont.appBarText).foregroundColor(.white)
                            } else if !isShowingMenu && currentTitle == "Store" {
                                Text("")
                            }
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            ZStack (alignment: .leading) {
                                HStack {
                                    Image("oneCoin")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    Text("\(vm.userDao.loggedUserScore ?? 0)")
                                        .font(Font.customFont.normalText)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                
                if isShowingMenu {
                    Rectangle()
                        .ignoresSafeArea()
                        .opacity(0.45)
                    SideMenuView(isShowing: $isShowingMenu, currentTitle: $currentTitle, currentView: $currentView)
                }
            }
            .background(Color("Background"))
            .onAppear {
                vm.userDao.getLoggedInUserScore()
            }
        }
    }
}

//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            MainView()
//                .previewInterfaceOrientation(.portrait)
//                .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
//
//        }
//    }
//}
