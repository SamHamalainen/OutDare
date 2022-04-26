//
//  ChangeInformation.swift
//  outdare
//
//  Created by Jasmin Partanen on 26.4.2022.
//

import SwiftUI

struct ChangeInformation: View {
    @ObservedObject private var vm = UserViewModel()
    @State var username: String
    @State var location: String
    @State var errorMessage = ""
    
    var body: some View {
        ZStack (alignment: .top) {
            RoundedRectangle(cornerRadius: 0)
                .fill(Color.theme.background2)
                .frame(height: 640)
            
            VStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("Username")
                    TextField("Username", text: $username)
                } .textFieldStyle(CustomTextFieldStyle())
                    .padding(.vertical, 20)
                
                VStack(alignment: .leading) {
                    Text("Location")
                    TextField(vm.currentUser?.location ?? "Location", text: $location)
                } .textFieldStyle(CustomTextFieldStyle())
                    .padding(.vertical, 20)
                
                Button {
                    updateUserDetails()
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
    }
    
    // Update user details to collection
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
