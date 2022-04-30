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
    
    
    @State var errorMessage = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        
//        ZStack (alignment: .top) {
//            RoundedRectangle(cornerRadius: 0)
//                .fill(Color.theme.background2)
//                .frame(height: 640)
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
//                .padding(.vertical, 20)
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
                
                SecureField("PASSWORD", text: $password)
                    .font(Font.customFont.normalText)
                    .padding()
                    .background(Color.theme.textLight)
                    .cornerRadius(20)
                    .shadow(color: .theme.icon, radius: 5, x: 3, y: 3)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                
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
                
                
//                ZStack (alignment: .top) {
//                    RoundedRectangle(cornerRadius: 0)
//                        .fill(Color.theme.background2)
//                        .frame(height: 640)
//                    VStack(alignment: .center) {
//                        Button {
//                            showImagePicker.toggle()
//                        } label: {
//                            VStack {
//                                if let image = self.image {
//                                    Image(uiImage: image)
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 128, height: 128)
//                                        .cornerRadius(64)
//                                } else {
//                                    if viewModel.currentUser?.profilePicture == "" {
//                                        Image(systemName: "person.fill")
//                                            .font(.system(size: 120))
//                                    } else {
//                                        WebImage(url: URL(string: viewModel.currentUser?.profilePicture ?? ""))
//                                            .resizable()
//                                            .frame(width: 120, height: 120)
//                                            .clipped()
//                                            .cornerRadius(120)
//                                    }
//                                }
//                            }
//                            .foregroundColor(Color.theme.textDark)
//                        }
//                        .padding(.vertical, 20)
//

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
            .navigationBarBackButtonHidden(true)
            .padding()
            
                .fullScreenCover(isPresented: $showImagePicker, onDismiss: nil) {
                    ImagePicker(image: $image)
                        }
    }
   
}

//struct SignUpForm_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpForm()
//    }
//}
