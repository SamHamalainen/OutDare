//
//  MainView.swift
//  outdare
//
//  Created by iosdev on 6.4.2022.
//

import SwiftUI

struct MainView: View {
    @State private var isShowingMenu = false
    @State private var currentTitle = "Map"
    @State private var currentView: AnyView = AnyView(MapView())
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                
                HomeView(currentView: currentView)
                    .cornerRadius(0)
                    .onTapGesture {
                        if (isShowingMenu) {
                            isShowingMenu = false
                        }
                        
                    }
                    .navigationBarItems(leading: Button(action: {
                        //showMenu.toggle()
                        withAnimation(.spring()) {
                            isShowingMenu.toggle()
                        }
                        
                    }, label: {Image(systemName: "list.bullet").foregroundColor(.white)}))
                    .navigationTitle(currentTitle)
                    .navigationBarTitleDisplayMode(.inline)
                    //.saturation(isShowingMenu ? 0 : 1)
                    .colorMultiply(isShowingMenu ? Color(UIColor.lightGray) : .white)
                    
                
                if isShowingMenu {
                    SideMenuView(isShowing: $isShowingMenu, currentView: $currentTitle, _view: $currentView)
                }
                
            }
            .background(Color("Background"))
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct HomeView: View {
    var currentView: AnyView = AnyView(MapView())
    
    var body: some View {
        ZStack {
            Color(.white)
            currentView
        }
    }
}

