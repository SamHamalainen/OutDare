//
//  UserSettings.swift
//  outdare
//
//  Created by Jasmin Partanen on 14.4.2022.
//
//import SwiftUI
//import FirebaseAuth
//import SDWebImageSwiftUI
//
//// Settings list for editing profile details
//struct UserSettings: View {
//    @ObservedObject private var vm = UserViewModel()
//    @State var showAlert = false
//
//    @State var username: String
//    @State var oldEmail: String
//    @State var newEmail = ""
//    @State var location: String
//    @State var oldPassword = ""
//    @State var newPassword = ""
//    @State var image: UIImage?
//    @State var errorMessage = ""
//
//    var body: some View {
//        ZStack (alignment: .top) {
//            RoundedRectangle(cornerRadius: 0)
//                .fill(Color.theme.background2)
//                .frame(height: 640)
//
//                VStack(alignment: .center) {
//                    VStack(alignment: .leading) {
//                    Text("Username")
//                    TextField("Username", text: $username)
//                    } .textFieldStyle(CustomTextFieldStyle())
//
//                    VStack(alignment: .leading) {
//                    Text("Email")
//                    TextField(vm.currentUser?.email ?? "Old email", text: $oldEmail)
//                    TextField("New email", text: $newEmail)
//                    } .textFieldStyle(CustomTextFieldStyle()).padding(.top, 5)
//
//                    VStack(alignment: .leading) {
//                    Text("Location")
//                    TextField(vm.currentUser?.location ?? "Location", text: $location)
//                    } .textFieldStyle(CustomTextFieldStyle()).padding(.top, 5)
//
//                    VStack(alignment: .leading) {
//                    Text("Password")
//                    SecureField("Old password", text: $oldPassword)
//                    SecureField("New password", text: $newPassword)
//                    } .textFieldStyle(CustomTextFieldStyle()).padding(.top, 5)
//
//                        Button {
//                            updateUserDetails()
//                        } label: {
//                                Text("UPDATE")
//                        }
//                            .padding()
//                            .frame(width: 100)
//                            .background(Color.theme.button)
//                            .foregroundColor(Color.theme.textLight)
//                            .cornerRadius(20)
//                }
//                .foregroundColor(Color.theme.textDark)
//                .font(Font.customFont.normalText)
//                .frame(width: 300)
//                .padding()
//            }
//        }
//
//    // Update user email and password to firebase auth
//    private func updateEmailAndPassword() {
//        let user = FirebaseManager.shared.auth.currentUser
//        let credentials = EmailAuthProvider.credential(withEmail: oldEmail, password: oldPassword)
//        user?.reauthenticate(with: credentials, completion: { (result, error) in
//           if let err = error {
//              print("\(err)")
//           } else {
//               user?.updateEmail(to: newEmail) { error in
//                   if let err = error {
//                       print(err)
//                       self.errorMessage = "\(err)"
//                       return
//                   }
//                   user?.updatePassword(to: newPassword) { error in
//                       if let err = error {
//                           print(err)
//                           self.errorMessage = "\(err)"
//                           return
//                       }
//                   }
//               }
//           }
//        })
//    }
//
//    // Update user details to collection
//    func updateUserDetails() {
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
//        let userData = ["email": newEmail, "username": username, "location": location]
//        FirebaseManager.shared.firestore.collection("users")
//            .document(uid).updateData(userData) { err in
//                    if let err = err {
//                        print(err)
//                        self.errorMessage = "\(err)"
//                        return
//                    }
//                    print("Success")
//                }
//            }
//}
//
//struct UserSettings_Previews: PreviewProvider {
//    static var vm = UserViewModel()
//    static var previews: some View {
//        UserSettings(username: vm.currentUser?.username ?? "", oldEmail: vm.currentUser?.email ?? "", location: vm.currentUser?.location ?? "")
//            .previewLayout(.sizeThatFits)
//    }
//}
