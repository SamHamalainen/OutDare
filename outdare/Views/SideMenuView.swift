//
//  SideMenuView.swift
//  outdare
//
//  Created by Tatu Ihaksi on 6.4.2022.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @Binding var currentTitle: String
    @Binding var currentView: AnyView
    @EnvironmentObject var loginViewModel: AppViewModel
    
    func signOut() {
        loginViewModel.signOut()
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color(.white)
            ZStack() {
                
                VStack {
                    ForEach(SideMenuViewModel.allCases, id: \.self) { item in
                        
                        Button(action: /*{withAnimation(.spring())*/{
                            currentTitle = item.title
                            isShowing.toggle()
                            currentView = AnyView(item.getView())
                            
                        }/*}*/, label: {SideMenuItem(viewModel: item)})
                    }
                    Button(action: signOut) {
                        HStack(spacing: 15) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .frame(width: 25, height: 25)
                            Text("Logout")
                                .font(.system(size: 15, weight: .semibold))
                            Spacer()
                        }
                        .foregroundColor(Color("DifficultyHard"))
                        .padding()
                    }
                }
            }
        }.frame(width: 200, height: 340).cornerRadius(20).ignoresSafeArea()
        
    }
}



/*struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true), currentView: "Map", _view: .constant(AnyView(MapView())))
    }
}*/
