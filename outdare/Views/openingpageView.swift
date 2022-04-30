//
//  StartView.swift
//  outdare
//
//  Created by Maiju Himberg on 8.4.2022.
//
import SwiftUI




//struct ContentView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @EnvironmentObject var viewModel: AppViewModel
//    var body: some View {
//
//        NavigationView {
//
//            if viewModel.signedIn {
////
//            }else{
//                LogInOrSignIn()
//            }
//
//        }
//        .onAppear{
//            viewModel.signedIn = viewModel.isSignedIn
//        }
//    }
//    }

struct OpeningPageView: View {
    
//    @State private var isPresented = false
    @Binding var login : Bool
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
                    login = true
                }
                .font(Font.customFont.btnText)
                .padding(.vertical, 10)
                .frame(width: 200)
                .background(Color.theme.button)
                .foregroundColor(Color.white)
                .cornerRadius(40)
                .offset(y:80)
                .shadow(color: .theme.icon, radius: 5, x: 3, y: 3)
            }
        }
//        .fullScreenCover(isPresented: $isPresented, content: ContentView.init)
    }
}
