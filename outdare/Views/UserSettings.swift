//
//  UserSettings.swift
//  outdare
//
//  Created by Jasmin Partanen on 14.4.2022.
//
import SwiftUI

// Settings list for editing profile details
struct UserSettings: View {
    @ObservedObject private var vm = UserViewModel()
    
    @State var openEditUsername = false
    @State var openEditEmail = false
    @State var openEditLocation = false
    @State var openEditPassword = false
    @State var showImagePicker = false
    
    @State var username = ""
    @State var email = ""
    @State var location = ""
    @State var password = ""
    
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
                            Image(systemName: "person.fill")
                                .font(.system(size: 64))
                                .padding()
                        }
                    }
                    .overlay(RoundedRectangle(cornerRadius: 64)
                        .stroke(Color.theme.textDark, lineWidth: 4))
                    .foregroundColor(Color.theme.textDark)
                }
                .padding(.vertical, 20)
            
                VStack(alignment: .center, spacing: 20) {
                    SettingsItem(placeholder: vm.currentUser?.username ?? "Username", text: username)
                    SettingsItem(placeholder: vm.currentUser?.email ?? "Email", text: email)
                    SettingsItem(placeholder: vm.currentUser?.location ?? "Location", text: location)
                    SettingsItem(placeholder: "Password", text: password)
                    Button("SAVE", action: vm.updateUsername)
                        .padding()
                        .frame(width: 100)
                        .background(Color.theme.button)
                        .foregroundColor(Color.theme.textLight)
                        .cornerRadius(20)
                }
                .frame(width: 200)
                .font(Font.customFont.normalText)
            }
        }
        .fullScreenCover(isPresented: $showImagePicker, onDismiss: nil) {
            ImagePicker(image: $image)
        }
    }
    @State var image: UIImage?
    @State var errorMessage = ""
    
    
    // Saving profile picture firebase storage
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
            }
        }
    }
}

struct UserSettings_Previews: PreviewProvider {
    static var previews: some View {
        UserSettings()
            .previewLayout(.sizeThatFits)
    }
}
