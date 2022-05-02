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
    @State var mute = UserDefaults.standard.bool(forKey: "mute")
    
    func signOut() {
        UserDefaults.standard.removeObject(forKey: "mute")
        loginViewModel.signOut()
    }
    
    func toggleSound() {
        mute.toggle()
        UserDefaults.standard.set(mute, forKey: "mute")
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color(.white)
            VStack (spacing: 25) {
                ForEach(SideMenuViewModel.allCases, id: \.self) { item in
                    Button(action: {
                        currentTitle = item.title
                        isShowing.toggle()
                    }, label: {SideMenuItem(viewModel: item)})
                    .accessibilityLabel(item.title)
                }
                HStack {
                    Button(action: toggleSound) {
                        HStack(spacing: 15) {
                            Image(systemName: "speaker.2")
                                .frame(width: 25, height: 25)
                            Text("Sound")
                                .font(.system(size: 15, weight: .semibold))
                            Toggle("", isOn: !$mute)
                                .allowsHitTesting(false)
                                .toggleStyle(SwitchToggleStyle(tint: Color.theme.background))
                                .scaleEffect(0.7)
                        }
                        .onChange(of: mute) {
                            UserDefaults.standard.set($0, forKey: "mute")
                            print(mute, UserDefaults.standard.bool(forKey: "mute"))
                        }
                        .foregroundColor(Color.theme.textDark)
                    }
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
                }
            }
            .padding()
        }.frame(width: 200, height: 445).cornerRadius(20).ignoresSafeArea()
    }
}



struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isShowing: .constant(true), currentTitle: .constant(LocalizedStringKey("Map")))
    }
}

extension Binding where Value == Bool {
    static prefix func !(_ lhs: Binding<Bool>) -> Binding<Bool> {
        return Binding<Bool>(get:{ !lhs.wrappedValue },
                             set: { lhs.wrappedValue = !$0})
    }
}
