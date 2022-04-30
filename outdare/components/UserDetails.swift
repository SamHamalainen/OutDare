//
//  UserDetails.swift
//  outdare
//
//  Created by Jasmin Partanen on 8.4.2022.
//
import SwiftUI
import SDWebImageSwiftUI

struct UserDetails: View {
    @ObservedObject private var vm = UserViewModel()
    @ObservedObject private var userDao = UserDAO()
    
    @State var showImagePicker = false
    @State var image: UIImage?
    @State var errorMessage = ""
    
    var body: some View {
        VStack {
                VStack(alignment: .center) {
                    Button {
                        showImagePicker.toggle()
                    } label: {
                        VStack {
                            if let image = self.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.width * 0.5)
                                    .cornerRadius(UIScreen.main.bounds.width * 0.25)
                            } else {
                                if vm.currentUser?.profilePicture == "" {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: UIScreen.main.bounds.width * 0.5))
                                } else {
                                    WebImage(url: URL(string: vm.currentUser?.profilePicture ?? ""))
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.width * 0.5)
                                        .clipped()
                                        .cornerRadius(UIScreen.main.bounds.width * 0.5)
                                }
                            }
                        }
                        .shadow(color: Color.theme.textDark, radius: 4, x: 4, y: 4)
                        .foregroundColor(Color.theme.textDark)
                    }
                
                Text(vm.currentUser?.username ?? "")
                    .font(Font.customFont.largeText)
                
                HStack {
                    Image(systemName: "mappin")
                    Text(vm.currentUser?.location ?? "")
                        .font(Font.customFont.normalText)
                }
                .padding(.vertical, UIScreen.main.bounds.height * 0.002)
                    }
            
                Label {
                    Text("\(userDao.loggedUserScore ?? 0)")
                        .font(Font.customFont.extraLargeText)
                        .foregroundColor(Color.theme.textLight)
                        .padding(15)
                } icon: {
                    Image(systemName: "dollarsign.circle.fill")
                        .foregroundColor(.yellow)
                        .padding(15)
                }
                .background(Color.theme.button)
                .cornerRadius(20)
                .opacity(0.75)
                .shadow(color: Color.theme.textDark, radius: 4, x: 4, y: 4)
        }
        .fullScreenCover(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
                .onDisappear {
                    saveImageToStorage()
            }
        }
    }
    
    // Saving profile picture to firebase storage
    func saveImageToStorage() {
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
                self.updateProfilePicture(imageProfileUrl: url)
            }
        }
    }
    
    // Update user details to collection
    func updateProfilePicture(imageProfileUrl: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["profilePicture": imageProfileUrl.absoluteString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).updateData(userData) { err in
                    if let err = err {
                        print(err)
                        self.errorMessage = "\(err)"
                        return
                    }
                    print("Profile picture updated")
                }
            }
        }


struct UserDetails_Previews: PreviewProvider {
    static var previews: some View {
        UserDetails()
            .previewLayout(.sizeThatFits)
    }
}
