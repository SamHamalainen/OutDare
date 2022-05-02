//
//  LogInView.swift
//  outdare
//
//  Created by Maiju Himberg on 19.4.2022.
//
import SwiftUI
import FirebaseAuth
import UIKit

//Authentication login form

struct LogInForm: View {
    
    @State var email = ""
    @State var password = ""
 
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        
        HStack {
            VStack {
                
                TextField("EMAIL", text: $email)
                    .font(Font.customFont.normalText)
                    .padding()
                    .background(Color.theme.textLight)
                    .cornerRadius(20)
                    .shadow(color: .theme.icon, radius: 5, x: 3, y: 3)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                
                SecureField("PASSWORD", text: $password)
                    .font(Font.customFont.normalText)
                    .padding()
                    .background(Color.theme.textLight)
                    .cornerRadius(20)
                    .shadow(color: .theme.icon, radius: 5, x: 3, y: 3)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                
                Button(action:{
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    viewModel.signIn(email: email, password: password)
                    
                    
                } , label: {
                    Text("LOGIN")
                        .font(Font.customFont.btnText)
                        .padding(.vertical, 10)
                        .frame(width: 200)
                        .background(Color.theme.button)
                        .foregroundColor(Color.white)
                        .cornerRadius(40)
                        .shadow(color: .theme.icon, radius: 5, x: 3, y: 3)
                    
                })
                .padding()
                
            }
            .padding()
            
        }
    }
}
