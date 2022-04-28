//
//  ChangeCredentials.swift
//  outdare
//
//  Created by Jasmin Partanen on 26.4.2022.
//

import SwiftUI
import FirebaseAuth

struct ChangeCredentials: View {
    @StateObject private var vm = UserViewModel()
    @State var oldEmail: String
    @State var newEmail = ""
    @State var oldPassword = ""
    @State var newPassword = ""
    @State var errorMessage = ""
    
    
    var body: some View {
        ZStack (alignment: .top) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.background2)
                .frame(height: 640)
            VStack {
                    VStack(alignment: .leading) {
                    Text("Email")
                    TextField(vm.currentUser?.email ?? "Old email", text: $oldEmail)
                    TextField("New email", text: $newEmail)
                    } .textFieldStyle(CustomTextFieldStyle())
                    .padding(.vertical, 20)
                        
                    VStack(alignment: .leading) {
                    Text("Password")
                    SecureField("Old password", text: $oldPassword)
                    SecureField("New password", text: $newPassword)
                    } .textFieldStyle(CustomTextFieldStyle())
                    .padding(.vertical, 20)
                        
                        Button {
                            updateEmailAndPassword()
                        } label: {
                                Text("UPDATE")
                        }
                            .padding()
                            .frame(width: 100)
                            .background(Color.theme.button)
                            .foregroundColor(Color.theme.textLight)
                            .cornerRadius(20)
                }
                .foregroundColor(Color.theme.textDark)
                .font(Font.customFont.normalText)
                .frame(width: 300)
                .padding()
            }
        .ignoresSafeArea(edges: .bottom)
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
            self.updateUserEmail()
        })
    }
    
    // Update user email to collection
    func updateUserEmail() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["email": newEmail]
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


struct ChangeCredentials_Previews: PreviewProvider {
    static var vm = UserViewModel()
    static var previews: some View {
        ChangeCredentials(oldEmail: vm.currentUser?.email ?? "")
    }
}
