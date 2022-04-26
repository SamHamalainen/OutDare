//
//  UserDAO.swift
//  outdare
//
//  Created by Sam Hämäläinen on 20.4.2022.
//

import Foundation
import Firebase

class UserDAO: ObservableObject {
    let db = Firestore.firestore()
    
    init() {
        getLoggedInUserScore()
    }
    
    @Published var errorMessage = ""
    @Published var loggedUserScore: Int?
    
    // Logged in user
//    @Published var currentUser: CurrentUser?
    
    func convertToUser(data: [String:Any]) -> CurrentUser {
        let id = data["userId"] as? Int ?? 0
        let username = data["username"] as? String ?? "no username"
        let email = data["email"] as? String ?? "no email"
        let location = data["location"] as? String ?? "Unknown location"
        let score = data["score"] as? Int ?? 0
        let goneUp = data["goneUp"] as? Bool ?? false
        let profilePicture = data["profilePicture"] as? String ?? "no picture"
        
        return CurrentUser(id: id, username: username, location: location, email: email, profilePicture: profilePicture, score: score, goneUp: goneUp)
    }
    
    // Fetching current user score
    func getLoggedInUserScore() {
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
            self.loggedUserScore = currentUser.score
        }
    }
    
    func updateUsersScore(newScore: Int) {
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
            guard let data = snapshot?.reference else {
                self.errorMessage = "No data found"
                return
            }
            data.updateData([
                "score": newScore
            ])
        }
        self.getLoggedInUserScore()
    }
}
