//
//  UserViewModel.swift
//  outdare
//  Created by Jasmin Partanen on 13.4.2022.
//  For fetching userdata from Firebase
//
import Foundation
import SDWebImageSwiftUI
import Firebase

class UserViewModel: ObservableObject {
    @Published var errorMessage = ""
    @Published var image: UIImage?
    
    // Logged in user
    @Published var currentUser: CurrentUser?
    
    // All users in the users db
    @Published var users: [CurrentUser] = []
    
    // Top users
    @Published var firstUser: CurrentUser? = nil
    @Published var secondUser: CurrentUser? = nil
    @Published var thirdUser: CurrentUser? = nil

    
    init() {
        fetchCurrentUser()
        fetchAllUsers()
    }
    
    func convertToUser(data: [String:Any]) -> CurrentUser {
        let id = data ["userId"] as? Int ?? 0
        let username = data["username"] as? String ?? ""
        let location = data["location"] as? String ?? ""
        let email = data["email"] as? String ?? ""
        let score = data["score"] as? Int ?? 0
        let goneUp = data["goneUp"] as? Bool ?? false
        
        return CurrentUser(id: id, username: username, location: location, email: email, score: score, goneUp: goneUp)
    }
    
    // Fetching current user
    private func fetchCurrentUser() {
        // Storing current user to uid
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Can not get firebase uid"
            return
        }
        // Accessing firebase collection with uid
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                return
            }
            guard let data = snapshot?.data() else {
                self.errorMessage = "No data found"
                return
            }
            let currentUser = self.convertToUser(data: data)
            self.currentUser = currentUser
        }
    }
    
    // Fetching all users
    private func fetchAllUsers() {
        let userRef = FirebaseManager.shared.firestore.collection("users")
        let query = userRef.order(by: "score", descending: true).limit(to: 20)
        query.getDocuments() { [self] (querySnapshot, error) in
            if let error = error {
                self.errorMessage = "Failed to fetch users: \(error)"
                print("Failed to fetch users: \(error)")
                return
            }
            let firstUser = querySnapshot!.documents[0]
            let secondUser = querySnapshot!.documents[1]
            let thirdUser = querySnapshot!.documents[2]
            
            let userOne = self.convertToUser(data: firstUser.data())
            let userTwo = self.convertToUser(data: secondUser.data())
            let userThree = self.convertToUser(data: thirdUser.data())
            
            self.firstUser = userOne
            self.secondUser = userTwo
            self.thirdUser = userThree
            
            for document in querySnapshot!.documents {
                let data = document.data()
                let user = self.convertToUser(data: data)
                users.append(user)
            }
            self.errorMessage = "Successfully fetched users"
        }
    }
}
