//
//  UserSettings.swift
//  outdare
//
//  Created by Jasmin Partanen on 14.4.2022.
//
import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI

// Settings list for editing profile details
struct UserSettings: View {
    @ObservedObject private var vm = UserViewModel()
    
    @State var showImagePicker = false
    @State var username = ""
    @State var oldEmail = ""
    @State var newEmail = ""
    @State var location = ""
    @State var oldPassword = ""
    @State var newPassword = ""
    @State var image: UIImage?
    @State var errorMessage = ""
    
    var body: some View {
        ZStack (alignment: .top) {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.theme.background2)
                .frame(height: 640)
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
                            if vm.currentUser?.profilePicture == "" {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 120))
                            } else {
                                WebImage(url: URL(string: vm.currentUser?.profilePicture ?? ""))
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .clipped()
                                    .cornerRadius(120)
                            }
                        }
                    }
                    .foregroundColor(Color.theme.textDark)
                }
                .padding(.vertical, 20)
            
                VStack(alignment: .center, spacing: 15) {
                        ZStack{
                    RoundedRectangle(cornerRadius: 20)
                    TextField(vm.currentUser?.username ?? "Username", text: $username)
                                .padding()
                                .foregroundColor(Color.theme.textDark)
                        }  .frame(width: 300, height: 50)
                        ZStack{
                    RoundedRectangle(cornerRadius: 20)
                    TextField(vm.currentUser?.email ?? "Old email", text: $oldEmail)
                                .padding()
                                .foregroundColor(Color.theme.textDark)
                        }   .frame(width: 300, height: 50)
                        ZStack{
                    RoundedRectangle(cornerRadius: 20)
                    TextField(vm.currentUser?.email ?? "New email", text: $newEmail)
                                .padding()
                                .foregroundColor(Color.theme.textDark)
                        }   .frame(width: 300, height: 50)
                        ZStack{
                    RoundedRectangle(cornerRadius: 20)
                    TextField(vm.currentUser?.location ?? "Location", text: $location)
                                .padding()
                                .foregroundColor(Color.theme.textDark)
                        }   .frame(width: 300, height: 50)
                        ZStack{
                    RoundedRectangle(cornerRadius: 20)
                    TextField("Old password", text: $oldPassword)
                                .padding()
                                .foregroundColor(Color.theme.textDark)
                        }   .frame(width: 300, height: 50)
                        ZStack{
                    RoundedRectangle(cornerRadius: 20)
                    TextField("New password", text: $newPassword)
                                .padding()
                                .foregroundColor(Color.theme.textDark)
                        }   .frame(width: 300, height: 50)
                    
                    Button {
                        saveImageToStorage()
                    } label: {
                            Text("UPDATE")
                    }
                        .padding()
                        .frame(width: 100)
                        .background(Color.theme.button)
                        .foregroundColor(Color.theme.textLight)
                        .cornerRadius(20)
                }
                .foregroundColor(Color.theme.transparent)
                .font(Font.customFont.normalText)
            }
        }
        .fullScreenCover(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }

    // Saving profile picture to firebase storage
    private func saveImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid
        else {return}
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else {return}
                
        ref.putData(imageData, metadata: nil) { metaData, error in
            if let error = error {
                self.errorMessage = "Failed to store image to storage \(error)"
                return
            }
            ref.downloadURL { url, error in
                if let error = error {
                    self.errorMessage = "Failed to get downloadUrl \(error)"
                    return
                }
                self.errorMessage = "Successfully stored image with url \(url?.absoluteString ?? "")"
                
                // Store url in collection
                guard let url = url else { return }
                self.updateEmailAndPassword()
                self.updateUserDetails(imageProfileUrl: url)
            }
        }
    }
    
    // Update user email and password to firebase auth
    private func updateEmailAndPassword() {
        let user = FirebaseManager.shared.auth.currentUser
        let credentials = EmailAuthProvider.credential(withEmail: oldEmail, password: oldPassword)
        user?.reauthenticate(with: credentials, completion: { (result, error) in
           if let err = error {
              print("\(err)")
           } else {
               user?.updateEmail(to: newEmail) { error in
                   if let err = error {
                       print(err)
                       self.errorMessage = "\(err)"
                       return
                   }
                   user?.updatePassword(to: newPassword) { error in
                       if let err = error {
                           print(err)
                           self.errorMessage = "\(err)"
                           return
                       }
                   }
               }
           }
        })
    }
    
    // Update user details to collection
    func updateUserDetails(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["profilePicture": imageProfileUrl.absoluteString, "email": newEmail, "username": username, "location": location]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).updateData(userData) { err in
                    if let err = err {
                        print(err)
                        self.errorMessage = "\(err)"
                        return
                    }
                    print("Success")
                }
            }

}

struct UserSettings_Previews: PreviewProvider {
    static var previews: some View {
        UserSettings()
            .previewLayout(.sizeThatFits)
    }
}
