//
//  LogInOrSignIn.swift
//  outdare
//
//  Created by Maiju Himberg on 19.4.2022.
//
import SwiftUI

struct LogInOrSignIn: View {
    @State var signUpIsShowing = false
    var body: some View {
        
        ZStack{
            Image("mapBackround")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    Button("LOGIN"){
                        signUpIsShowing = false
                        
                    }
                    .font(Font.customFont.btnText)
                    .foregroundColor(signUpIsShowing ? .theme.icon :.theme.textDark)
                    
                    Button("SIGNUP"){
                        signUpIsShowing = true
                        
                    }
                    .font(Font.customFont.btnText)
                    .foregroundColor(signUpIsShowing ? .theme.textDark :.theme.icon)
                }
                .padding()
                
                if(signUpIsShowing == false){
                    LogInForm()
                }
                else{
                    SignUpForm()
                }
            }
            
            .background(Color.theme.transparent)
            .cornerRadius(20)
            .shadow(color: .theme.icon, radius: 5, x: 3, y: 3)
            .padding(.horizontal, 20)
        }
    }
}



struct LogInOrSignIn_Previews: PreviewProvider {
    static var previews: some View {
        LogInOrSignIn()
    }
}
