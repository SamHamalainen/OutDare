//  ChangeCredentials.swift
//  outdare
//  Created by Jasmin Partanen on 26.4.2022.
//  Description: View for changing user password and email
import SwiftUI
import FirebaseAuth
import Combine

struct ChangeCredentials: View {
    @StateObject private var vm = UserViewModel()
    @State var oldEmail: String
    @State var newEmail = ""
    @State var oldPassword = ""
    @State var newPassword = ""
    @State var errorMessage = ""
    @State var showValidationMessage = false
    @State var message: String?
    
    
    var body: some View {
        ZStack (alignment: .top) {
            Color.theme.background2
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 120, height: 5)
                .padding()
                .foregroundColor(Color.theme.button)
            
            VStack {
                Text("Change credentials")
                    .font(Font.customFont.largeText)
                    .padding(.top, 60)
                
                Section(header: Text("Email")) {
                    TextField(vm.currentUser?.email ?? "Old email", text: $oldEmail)
                    TextField("New email", text: $newEmail)
                }
                .padding(.vertical, 2)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                
                Section(header: Text("Password")) {
                    SecureField("Old password", text: $oldPassword)
                    SecureField("New password", text: $newPassword)
                }
                .padding(.vertical, 2)
                .keyboardType(.default)
                .autocapitalization(.none)
                
                // Conditions for field validation messages on button click
                Section {
                    if showValidationMessage {
                        Text(message ?? "")
                            .foregroundColor(Color.theme.difficultyHard)
                            .padding(.vertical, 10)
                    }
                    Button {
                        // If validationError equals to string, show it in the message
                        // ValidCredentials checks is email and password is valid
                        if let validationError = validCredentials(newEmail: newEmail, oldPassword: oldPassword, newPassword: newPassword) {
                            showValidationMessage = true
                            message = validationError
                            return
                        }
                        // if validCredentials equals to nil, update email and password
                        updateEmailAndPassword()
                        
                    } label: {
                        Text("UPDATE")
                    }
                    .padding()
                    .background(Color.theme.button)
                    .foregroundColor(Color.theme.textLight)
                    .cornerRadius(20)
                }
            }
            .foregroundColor(Color.theme.textDark)
            .font(Font.customFont.normalText)
            .frame(width: 300)
            .padding()
            .textFieldStyle(RoundedTextFieldStyle(alignment: .leading))
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    // Update user email and password to firebase auth
    private func updateEmailAndPassword() {
        let user = FirebaseManager.shared.auth.currentUser
        let credentials = EmailAuthProvider.credential(withEmail: oldEmail, password: oldPassword)
        
        // Reauthenticate user before updating credentials
        user?.reauthenticate(with: credentials, completion: { (result, error) in
            if let err = error {
                print("\(err)")
            } else {
                
                // Update email
                user?.updateEmail(to: newEmail) { error in
                    if let err = error {
                        print(err)
                        self.errorMessage = "\(err)"
                        return
                    }
                    
                    // Update password
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
    
    // Update user email to users collection
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
