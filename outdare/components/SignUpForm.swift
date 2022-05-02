//
//  SignUpForm.swift
//  outdare
//
//  Created by Maiju Himberg on 19.4.2022.
//
import SwiftUI
import SDWebImageSwiftUI
import FirebaseFirestore


struct SignUpForm: View {
    @State var showImagePicker = false
    @State var email = ""
    @State var password = ""
    @State var username = ""
    @State var location = ""
    @State var image: UIImage?
    @State var showPassword = false
    
    
    @State var errorMessage = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
//        By clicking  replacement profile picture, opens image picker and user can choose picture from phone.
        VStack(alignment: .center) {
            Button {
                showImagePicker.toggle()
            } label: {
                VStack {
                    
                    if let image = self.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 128, height: 128)
                            .cornerRadius(64)
                    } else {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 120))
                    }
                }
                .foregroundColor(Color.theme.textDark)
            }
            
        }
        VStack {
            
            TextField("EMAIL", text: $email)
                .font(Font.customFont.normalText)
                .padding()
                .background(Color.theme.textLight)
                .cornerRadius(20)
                .shadow(color: .theme.icon, radius: 5, x: 3, y: 3)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            if !showPassword {
                ZStack {
                    SecureField("PASSWORD", text: $password)
                        .font(Font.customFont.normalText)
                        .padding()
                        .background(Color.theme.textLight)
                        .cornerRadius(20)
                        .shadow(color: .theme.icon, radius: 5, x: 3, y: 3)
                        .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    HStack {
                        Spacer()
                        Image(systemName: "eye")
                            .padding(.trailing, 10)
                            .onTapGesture {
                                showPassword.toggle()
                        }
                    }
                }
            } else {
                ZStack {
                    TextField("PASSWORD", text: $password)
                        .font(Font.customFont.normalText)
                        .padding()
                        .background(Color.theme.textLight)
                        .cornerRadius(20)
                        .shadow(color: .theme.icon, radius: 5, x: 3, y: 3)
                        .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    HStack {
                        Spacer()
                        Image(systemName: "eye.slash")
                            .padding(.trailing, 10)
                            .onTapGesture {
                                showPassword.toggle()
                        }
                    }
                }
            }
            
            TextField("USERNAME", text: $username)
                .font(Font.customFont.normalText)
                .padding()
                .background(Color.theme.textLight)
                .cornerRadius(20)
                .shadow(color: .theme.icon, radius: 5, x: 3, y: 3)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
            
            TextField("COUNTRY", text: $location)
                .font(Font.customFont.normalText)
                .padding()
                .background(Color.theme.textLight)
                .cornerRadius(20)
                .shadow(color: .theme.icon, radius: 5, x: 3, y: 3)
            
            
            Button(action:{
                guard !email.isEmpty, !password.isEmpty, !username.isEmpty, !location.isEmpty else {
                    return
                    
                }
                viewModel.signUp(email: email, password: password, username: username, location: location)
                
            } , label: {
                Text("SIGNUP")
                    .font(Font.customFont.btnText)
                    .padding(.vertical, 10)
                    .frame(width: 200)
                    .background(Color.theme.button)
                    .foregroundColor(Color.white)
                    .cornerRadius(40)
                    .shadow(color: .theme.icon, radius: 5, x: 3, y: 3)
                    .padding()
                
            })
            
            
            
        }
        .onChange(of: image){
            viewModel.image = $0
        }

        .padding()
        
        .fullScreenCover(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
}
