//
//  SideMenuView.swift
//  outdare
//
//  Created by Tatu Ihaksi on 6.4.2022.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @Binding var currentView: String
    @Binding var _view: AnyView
    var body: some View {
        ZStack(/*alignment: .topTrailing*/) {
            Color(.white)
                //.ignoresSafeArea()
            
            ZStack(/*alignment: .topTrailing*/) {
                
                VStack() {
                    ForEach(SideMenuViewModel.allCases, id: \.self) { item in
                        
                        Button(action: {withAnimation(.spring()){
                            currentView = item.title
                            isShowing.toggle()
                            _view = AnyView(item.getView())
                            
                        }}, label: {SideMenuItem(viewModel: item)})
                    }
                    //Spacer()
                }
            }
        }.navigationBarHidden(true).frame(width: 200, height: 300).cornerRadius(20).ignoresSafeArea()
        
    }
}

/*struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true), currentView: "Map", _view: .constant(AnyView(MapView())))
    }
}*/
