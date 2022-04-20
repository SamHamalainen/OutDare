//
//  SignUpForm.swift
//  outdare
//
//  Created by Maiju Himberg on 19.4.2022.
//
import SwiftUI

struct SignUpForm: View {
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
                
                SecureField("PASSWORD", text: $password)
                    .font(Font.customFont.normalText)
                    .padding()
                    .background(Color.theme.textLight)
                    .cornerRadius(20)
                    .shadow(color: .theme.icon, radius: 5, x: 3, y: 3)
                Button(action:{
                    
                    guard !email.isEmpty, !password.isEmpty else {
                        return
                    }
                    
                    viewModel.signUp(email: email, password: password)
                    
                } , label: {
                    Text("SIGNUP")
                        .font(Font.customFont.btnText)
                        .padding(.vertical, 10)
                        .frame(width: 200)
                        .background(Color.theme.button)
                        .foregroundColor(Color.white)
                        .cornerRadius(40)
                        .shadow(color: .theme.icon, radius: 5, x: 3, y: 3)
                    
                })
               
            }
            .navigationBarBackButtonHidden(true)
            .padding()
            Spacer()
            
        }
//        .frame(width: 280, height: 250)
//        .background(Color.theme.transparent)
//        .cornerRadius(20)
//        .shadow(color: .theme.icon, radius: 5, x: 3, y: 3)
        }
    }



struct SignUpForm_Previews: PreviewProvider {
    static var previews: some View {
        SignUpForm()
    }
}
