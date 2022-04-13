//
//  Profile.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//

import SwiftUI
import Firebase

struct UserProfile: View {
    
    // for login functionality -- will be deleted
    @State var isLoginMode = false
    @State var email = "tester@gmail.com"
    @State var password = "Test1234"
    @State var loginStatusMessage = ""
    
    private func handleAction() {
        if isLoginMode {
        loginUser()
        }
    }
    
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Failed to login", error)
                self.loginStatusMessage = "Failed to login user: \(error)"
                return
            }
            print("Successfully logged in as user: \(result?.user.uid ?? "")")

            self.loginStatusMessage = "Successfully logged in as user: \(result?.user.uid ?? "")"
        }
    }
    // delete area ends here
    
    var body: some View {
        ZStack {
            ProfileBackground()
            UserDetails()
                .offset(y: -140)
            Image(systemName: "ellipsis")
                .resizable()
                .frame(width: 40, height: 8)
                .offset(x: -170, y: -150)
                .foregroundColor(Color.theme.button)
                .rotationEffect(Angle(degrees: 90))

            Button {
                isLoginMode = true
                handleAction()
            } label: {
                Text(isLoginMode ? "Achievements" : "login")
                    .font(Font.customFont.largeText)
                    .frame(maxWidth: 320, maxHeight: 220, alignment: .bottomLeading)
            }
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
