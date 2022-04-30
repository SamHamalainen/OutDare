//
//  AppViewModel.swift
//  outdare
//
//  Created by Maiju Himberg on 25.4.2022.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseStorage

class AppViewModel: ObservableObject {
    @Published var userDao = UserDAO()
    @Published var errorMessage = ""
    @Published var image: UIImage?
    
    // Logged in user
    @Published var currentUser: CurrentUser?
    
    // All users in the users db
//    @Published var users: [CurrentUser] = []
    
//    private var userDetails = UserDetails()
    
//    init() {
//        fetchCurrentUser()
//        fetchAllUsers()
//    }
    
    
    
//    func convertToUser(data: [String:Any]) -> CurrentUser {
//        let id = data ["userId"] as? Int ?? 0
//        let username = data["username"] as? String ?? ""
//        let location = data["location"] as? String ?? ""
//        let email = data["email"] as? String ?? ""
//        let profilePicture = data["profilePicture"] as? String ?? ""
//        let score = data["score"] as? Int ?? 0
//        let goneUp = data["goneUp"] as? Bool ?? false
//
//
//        return CurrentUser(id: id, username: username, location: location, email: email, profilePicture: profilePicture, score: score, goneUp: goneUp)
//    }
    
    
    
    // Fetching current user
//    private func fetchCurrentUser() {
//        // Storing current user to uid
//        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
//            self.errorMessage = "Can not get firebase uid"
//            return
//        }
//        // Accessing firebase collection with uid
//        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
//            if let error = error {
//                self.errorMessage = "Failed to fetch current user: \(error)"
//                return
//            }
//            guard let data = snapshot?.data() else {
//                self.errorMessage = "No data found"
//                return
//            }
//            let currentUser = self.convertToUser(data: data)
//            self.currentUser = currentUser
//        }
//    }

//    Authentication
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password){[weak self] result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
            //Success
            self?.signedIn = true
            }
    }
    }
    func signUp(email: String, password: String, username: String, location: String){
        auth.createUser(withEmail: email, password: password){[weak self] result, error in
            guard result != nil, error == nil else {
                return
        }
            DispatchQueue.main.async {
                //Success
                    self?.signedIn = true
        }
//            self?.saveImageToStorage(profilePicture:)
            self?.saveImageToStorage(email: email, username: username, location: location)
            


        }
}
    
    // Add user details to collection
    func addUserDetails(email: String, username: String, location: String, profilePicture: URL?) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let urlString = profilePicture?.absoluteString ?? ""
        let userData = ["email": email, "username": username, "location": location, "profilePicture": urlString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData){ err in
                    if let err = err {
                        print(err)
                        self.errorMessage = "EI TOIMI"
                        return
                    }
                
                print()
                    print("Success")
                }
            }
    private func saveImageToStorage(email: String, username: String, location: String) {
        if self.image != nil {
            
        
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid
            else {return}
            let ref = FirebaseManager.shared.storage.reference(withPath: uid)
            guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else {return}
                    
            ref.putData(imageData, metadata: nil) { metaData, error in
                if let error = error {
                    self.errorMessage = "EI SITTEN MILLÄÄÄÄÄÄN\(error)"
                    return
                }
                ref.downloadURL { url, error in
                    if let error = error {
                        self.errorMessage = "EI ONNISTU MILLÄÄN \(error)"
                        return
                    }
                    self.errorMessage = "EI ONNISTU \(url?.absoluteString ?? "")"
                    
                    // Store url in collection
                    guard let url = url else { return }
                    print("WORKING")
                    self.addUserDetails(email: email, username: username, location: location, profilePicture: url)
                }
            }
        }
        else{
            self.addUserDetails(email: email, username: username, location: location, profilePicture: nil)
        }
    }
        
//    func updateProfilePicture(imageProfileUrl: URL) {
//           guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
//           let userData = ["profilePicture": imageProfileUrl.absoluteString]
//           FirebaseManager.shared.firestore.collection("users")
//               .document(uid).setData(userData) { err in
//                       if let err = err {
//                           print(err)
//                           self.errorMessage = "\(err)"
//                           return
//                       }
//                       print("Profile picture updated")
//                   }
//               }
//

   


    
    func signOut(){
        try? auth.signOut()
        self.signedIn = false
        
    }
    }
