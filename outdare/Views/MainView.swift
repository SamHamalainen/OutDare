//
//  MainView.swift
//  outdare
//
//  Created by Tatu Ihaksi on 6.4.2022.
//

import SwiftUI
/// Applications main view. Selected view (map, leaderboard, profile or store) is rendered inside the navigationview.
struct MainView: View {
    @State private var isShowingMenu = false
    @State private var currentTitle = LocalizedStringKey("Map")
    @StateObject private var userDao = UserDAO()
    @EnvironmentObject var vm: AppViewModel
    private let mapView = MapView()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                
                // View that displays the selected view
                selectedView
                .navigationBarTitleDisplayMode(.inline).toolbar {
                    toolBarContent()
                }
                
                if isShowingMenu {
                    // Makes views under under menu darker
                    Rectangle()
                        .ignoresSafeArea()
                        .opacity(0.45)
                        .onTapGesture {
                            isShowingMenu = false
                        }
                    SideMenuView(isShowing: $isShowingMenu, currentTitle: $currentTitle)
                }
            }
            .background(Color("Background"))
        }
    }
    /// View that is selected from the menu. Initially is the map view
    private var selectedView: some View {
        ZStack {
            Color(.white)
            switch currentTitle {
            case "Map":
                mapView
            case "Leaderboard":
                Leaderboard()
            case "Profile":
                UserProfile()
            case "Generator":
                QuizGeneratorView()
            case "Store":
                PointPurchaseView()
            default:
                mapView
            }
        }
    }
    /// Navigations bar's content. Includes menu button, header and coins
    @ToolbarContentBuilder
    private func toolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            menuButton
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
                    Spacer()
                    Image("oneCoin")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("\(userDao.loggedUserScore ?? 0)")
                        .font(Font.customFont.normalText)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .frame(minWidth: UIScreen.main.bounds.width * 0.35, minHeight: 24, alignment: .trailing)
            }
        }
    }
    private var menuButton: some View {
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
