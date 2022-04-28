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
        let id = data["userId"] as? String ?? ""
        let username = data["username"] as? String ?? "no username"
        let email = data["email"] as? String ?? "no email"
        let location = data["location"] as? String ?? "Unknown location"
        let score = data["score"] as? Int ?? 0
        let profilePicture = data["profilePicture"] as? String ?? "no picture"
        
        return CurrentUser(id: id, username: username, location: location, email: email, profilePicture: profilePicture, score: score)
    }
    
    // Fetching current user achievements
    func getLoggedInUserScore() {
        // Storing current user to uid
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Can not get firebase uid"
            return
        }
        
        let attemptRef = FirebaseManager.shared.firestore.collection("attempts")
        let query = attemptRef.whereField("userId", isEqualTo: uid)
        query.addSnapshotListener() {[self] (querySnapshot, err) in
            if let err = err {
                print("Error getting achievements: \(err)")
            }
            var scores: [Int] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let score = data["score"] as? Int ?? 0
                    // print("scoreInLogged: \(score)")
                    scores.append(score)
                }
            self.loggedUserScore = scores.reduce(0, +)
            print("score: \(self.loggedUserScore!)")
            }
        }
    
    func addAttempt(attempt: Attempt) {
        if var score = self.loggedUserScore {
            score += attempt.score
        }
        let attemptRef = db.collection("attempts")
        var data = attempt.toDB()
        data["data"] = Timestamp()
        attemptRef.addDocument(data: data) { err in
            if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added!")
                }
        }
    }
    
    func updateUsersScore(newScore: Int) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Can not get firebase uid"
            return
        }
        let attempt = Attempt(userId: uid, challengeId: -1, score: newScore, time: nil)
        addAttempt(attempt: attempt)
    }
    
    func updateWalkingScore() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Can not get firebase uid"
            return
        }
        let name = "\(uid)-walking"
        let walkRef = db.collection("attempts").document(name)
        walkRef.getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                return
            }
            if let snapshot = snapshot {
                if snapshot.exists {
                    walkRef.updateData([
                        "score": FieldValue.increment(Int64(5))
                    ])
                } else {
                    walkRef.setData([
                        "userId": uid,
                        "challengeId": -1,
                        "score": 5
                    ])
                }
            }
            
            
        }
    }
}
