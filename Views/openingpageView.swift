//
//  StartView.swift
//  outdare
//
//  Created by Maiju Himberg on 8.4.2022.
//
import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject {
    @Published var userDao = UserDAO()
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    @Published var userLoggedInEmail: String?
    
    func getCurrentUser() {
        let user = auth.currentUser
        if user != nil {
            userDao.loggedInUserEmail = user?.email
        } else {
            print("no user")
        }
    }
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password){[weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
            //Success
            self?.signedIn = true
            }
    }
    }
    func signUp(email: String, password: String){
        auth.createUser(withEmail: email, password: password){[weak self] result, error in
            guard result != nil, error == nil else {
                return
        }
            DispatchQueue.main.async {
                //Success
                    self?.signedIn = true
            }
        
    }
    
}
    func signOut(){
        try? auth.signOut()
        self.signedIn = false
        
    }
    }


struct ContentView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: AppViewModel
    var body: some View {
        
        NavigationView {
            
            if viewModel.signedIn {
//                VStack{
//                    Button(action: {viewModel.signOut()}, label: {Text("Sign Out")
//                            .foregroundColor(Color.pink)
//                    })
//                    Text("Welcome")
//                }
            }else{
                LogInOrSignIn()
            }
            
        }
        .onAppear{
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
    }

struct openingpageView: View {
    
    @State private var isPresented = false
    
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
                    isPresented.toggle()
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
        .fullScreenCover(isPresented: $isPresented, content: ContentView.init)
    }
}
