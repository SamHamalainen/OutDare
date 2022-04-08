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
                        withAnimation(.spring()) {
                            isShowingMenu.toggle()
                        }
                        
                    }, label: {Image(systemName: "list.bullet").foregroundColor(.white)}))
                    //.navigationTitle(currentTitle)
                    .navigationBarTitleDisplayMode(.inline).toolbar {
                        ToolbarItem(placement: .principal) {
                            Text(currentTitle).font(Font.customFont.appBarText).foregroundColor(.white)
                        }
                    }
                    //.saturation(isShowingMenu ? 0 : 1)
                    .colorMultiply(isShowingMenu ? Color(UIColor.lightGray) : .white)
                    //.grayscale(isShowingMenu ? 0.9 : 0)
                    
             
                
                if isShowingMenu {
                    SideMenuView(isShowing: $isShowingMenu, currentTitle: $currentTitle, currentView: $currentView)
                }
                
            }
            .background(isShowingMenu ? Color("BackgroundDark") : Color("Background"))
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView()
                .previewInterfaceOrientation(.portrait)
                .previewDevice(PreviewDevice(rawValue: "iPhone 13"))
            
        }
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

