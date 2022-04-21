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
    
    @Published var loggedInUserEmail: String?
    @Published var loggedUserScore: Int?
    
    func convertoToUser(data: [String:Any]) -> User {
        let id = data["userId"] as? Int ?? 0
        let username = data["username"] as? String ?? "no username"
        let score = data["score"] as? Int ?? 0
        let goneUp = data["goneUp"] as? Bool ?? false
        let profilePicture = data["profilePicture"] as? String ?? "no picture"
        
        return User(id: id, username: username, score: score, goneUp: goneUp, profilePicture: profilePicture)
    }
    
    func getLoggedInUserScore() {
        let userEmail = self.loggedInUserEmail ?? "no email"
        let userRef = db.collection("users")
        let query = userRef.whereField("email", isEqualTo: userEmail)
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let document = querySnapshot!.documents[0]
                let user = self.convertoToUser(data: document.data())
                self.loggedUserScore = user.score
            }
        }
    }
    func updateUsersScore(newScore: Int) {
        let userEmail = self.loggedInUserEmail ?? "no email"
        let userRef = db.collection("users")
        let query = userRef.whereField("email", isEqualTo: userEmail)
        query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let document = querySnapshot!.documents[0]
                document.reference.updateData([
                    "score": newScore
                ])
            }
        }
    }
}
