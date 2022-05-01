//  ChangeInformation.swift
//  outdare
//  Created by Jasmin Partanen on 26.4.2022.
//  Description: View to edit profile username and location

import SwiftUI

struct ChangeInformation: View {
    @StateObject private var vm = UserViewModel()
    @State var errorMessage = ""
    @State var username: String
    @State var location: String
    @State var showValidationMessage = false
    @State var message: String?
    
    var body: some View {
        ZStack (alignment: .top) {
            Color.theme.background2
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 120, height: 5)
                .padding()
                .foregroundColor(Color.theme.button)
            
            VStack(alignment: .center) {
                Text("Change information")
                    .font(Font.customFont.largeText)
                    .padding(.top, 60)
                
                Section(header: Text("Username")) {
                    TextField("Username", text: $username)
                    Text("Location")
                    TextField(vm.currentUser?.location ?? "Location", text: $location)
                }
                .autocapitalization(.none)
                .padding(.vertical, 5)
                
                // Field validation
                Section {
                    if showValidationMessage {
                        Text(message ?? "")
                            .foregroundColor(Color.theme.difficultyHard)
                            .padding(.vertical, 10)
                    }
                    Button {
                        if let validationError = validInformation(location: location, username: username) {
                            showValidationMessage = true
                            message = validationError
                            return
                        }
                        updateUserDetails()
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
            .padding(.horizontal, 40)
            .textFieldStyle(RoundedTextFieldStyle(alignment: .leading))
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    // Update username and locaton to users collection
    func updateUserDetails() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = ["username": username, "location": location]
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

struct ChangeInformation_Previews: PreviewProvider {
    static var vm = UserViewModel()
    static var previews: some View {
        ChangeInformation(username: vm.currentUser?.username ?? "", location: vm.currentUser?.location ?? "")
    }
}
