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
    
    
    //    Authentication
    
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    //    Signs user in from loginForm
    func signIn(email: String, password: String){
        auth.signIn(withEmail: email, password: password){[weak self] result, error in
            guard result != nil, error == nil else {
                print("Something went wrong")
                return
                
            }
            DispatchQueue.main.async {
                //Success
                self?.signedIn = true
            }
        }
    }
    //    Creates user with email and password and signs user in
    func signUp(email: String, password: String, username: String, location: String){
        auth.createUser(withEmail: email, password: password){[weak self] result, error in
            guard result != nil, error == nil else {
                return
                
            }
            DispatchQueue.main.async {
                //Success
                self?.signedIn = true
            }
            self?.saveImageToStorage(email: email, username: username, location: location)
        }
    }
    
    // Create username, location and profilepicture to users collection
    func addUserDetails(email: String, username: String, location: String, profilePicture: URL?) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let urlString = profilePicture?.absoluteString ?? ""
        let userData = ["email": email, "username": username, "location": location, "profilePicture": urlString]
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData){ err in
                if let err = err {
                    print(err)
                    self.errorMessage = "Not working"
                    return
                }
                
                print()
                print("Success")
            }
    }
    //    Saves profilepicture to the Firebase storage
    
    private func saveImageToStorage(email: String, username: String, location: String) {
        if self.image != nil {
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
                    print(" JEEE ITS WORKING")
                    self.addUserDetails(email: email, username: username, location: location, profilePicture: url)
                }
            }
        }
        else{
            //            if user dont wnat to change profile picture it gives nil value for it
            self.addUserDetails(email: email, username: username, location: location, profilePicture: nil)
        }
    }
    
    
    //   Authentication signout function
    
    func signOut(){
        try? auth.signOut()
        self.signedIn = false
        
    }
}
