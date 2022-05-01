//
//  SideMenuView.swift
//  outdare
//
//  Created by Tatu Ihaksi on 6.4.2022.
//

import SwiftUI
/// View for the side menu. Has a vertical list of buttons which change the view inside the mainView's navigationView
/// plus the logout button.
struct SideMenuView: View {
    @Binding var isShowing: Bool
    @Binding var currentTitle: LocalizedStringKey
    @EnvironmentObject var loginViewModel: AppViewModel
    
    func signOut() {
        loginViewModel.signOut()
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color(.white)
                VStack {
                    ForEach(SideMenuViewModel.allCases, id: \.self) { item in
                        
                        Button(action: {
                            currentTitle = item.title
                            isShowing.toggle()
                        }, label: {SideMenuItem(viewModel: item)})
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
            }.frame(width: 200, height: 460).cornerRadius(20).ignoresSafeArea()
        }
    }



/*struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true), currentView: "Map", _view: .constant(AnyView(MapView())))
    }
}*/
