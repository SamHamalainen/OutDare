//
//  StartView.swift
//  outdare
//
//  Created by Maiju Himberg on 8.4.2022.
//

import SwiftUI



struct StartView: View {
    var body: some View {
        ZStack{
            Image("mapBackround")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
            VStack{
                Image("ChucLogo")
                    .resizable()
                    
                    .scaledToFit()
                    .frame(width: 200.0)

                    
                Image("OutDareLogo")
                    .resizable()
                    .padding(.top)
                    .scaledToFit()
                    .frame(width: 200.0)
                    
            Button("CONTINUE") {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                
            }
            .font(Font.customFont.btnText)
            .padding(.vertical, 10)
            .frame(width: 200)
            .background(Color.theme.button)
            .foregroundColor(Color.white)
            .cornerRadius(40)
            .offset(y:80)
            }
            
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
