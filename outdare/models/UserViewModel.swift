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
    @Published var userScore: Int?
    @Published var usersWithScores: [CurrentUser] = []
    
    // Top users
    @Published var firstUser: CurrentUser? = nil
    @Published var secondUser: CurrentUser? = nil
    @Published var thirdUser: CurrentUser? = nil
    
    private var achievements: [Achievement] = []
    @Published var achievementsWithCategory: [Achievement] = []

    
    init() {
        fetchCurrentUser()
        fetchAllUsers()
    }
    
    func convertToUser(data: [String:Any]) -> CurrentUser {
        let id = data ["userId"] as? String ?? ""
        let username = data["username"] as? String ?? ""
        let location = data["location"] as? String ?? ""
        let email = data["email"] as? String ?? ""
        let profilePicture = data["profilePicture"] as? String ?? ""
        let score = data["score"] as? Int ?? 0
        let goneUp = data["goneUp"] as? Bool ?? false
        
        return CurrentUser(id: id, username: username, location: location, email: email, profilePicture: profilePicture, score: score, goneUp: goneUp)
    }
    
    func convertToAchievement(data: [String:Any]) -> Achievement {
        let id = data ["challengeId"] as? Int ?? 0
        let score = data["score"] as? Int ?? 0
        let time = data["time"] as? Int ?? 0
        let userId = data["userId"] as? Int ?? 0
        let date = data["date"] as? Date ?? Date()
        let speedBonus = data["speedBonus"] as? Bool ?? false
        return Achievement(id: id, score: score, time: time, userId: userId, date: date, speedBonus: speedBonus, category: "")
    }
    
    func convertToCategory(data: [String:Any]) -> Category {
        let name = data ["category"] as? String ?? ""
        return Category(name: name)
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
            self.fetchLoggedUserAchievements(uid: uid)
        }
    }
    
    // Fetching all users
    private func fetchAllUsers() {
        let userRef = FirebaseManager.shared.firestore.collection("users")
        let query = userRef.limit(to: 20)
        query.getDocuments() { [self] (querySnapshot, error) in
            if let error = error {
                self.errorMessage = "Failed to fetch users: \(error)"
                print("Failed to fetch users: \(error)")
                return
            }
            // Will be deleted
            let firstUser = querySnapshot!.documents[0]
            let secondUser = querySnapshot!.documents[1]
            let thirdUser = querySnapshot!.documents[2]
            let userOne = self.convertToUser(data: firstUser.data())
            let userTwo = self.convertToUser(data: secondUser.data())
            let userThree = self.convertToUser(data: thirdUser.data())
            self.firstUser = userOne
            self.secondUser = userTwo
            self.thirdUser = userThree
            // Will be deleted
            
            for document in querySnapshot!.documents {
                let data = document.data()
                let uid = document.documentID
                let user = self.convertToUser(data: data)
                fetchAllScores(uid: uid)
                
                usersWithScores.append(CurrentUser(id: uid, username: user.username, location: user.location, email: user.email, profilePicture: user.profilePicture, score: userScore ?? 0, goneUp: user.goneUp))
            }
            self.errorMessage = "Successfully fetched users"
        }
        
        print("users", self.usersWithScores.last ?? "")
    }
    
    // Fetching current user achievements
    func fetchAllScores(uid: String) {
        let attemptRef = FirebaseManager.shared.firestore.collection("attempts")
        let query = attemptRef.whereField("userId", isEqualTo: uid)
        query.getDocuments() {[self] (querySnapshot, err) in
            if let err = err {
                print("Error getting user attempts: \(err)")
            }
            var scores: [Int] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let score = data["score"] as? Int ?? 0
                    scores.append(score)
                }
            self.userScore = scores.reduce(0, +)
            }
        }
    
    // Fetching current user achievements
    func fetchLoggedUserAchievements(uid: String) {
        let attemptRef = FirebaseManager.shared.firestore.collection("attempts")
        let query = attemptRef.whereField("userId", isEqualTo: uid)
        query.getDocuments() {[self] (querySnapshot, err) in
            if let err = err {
                print("Error getting user attempts: \(err)")
            }
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let achievement = self.convertToAchievement(data: data)
                    achievements.append(achievement)
                    print(self.achievements)
                }
            let filtered = achievements.filter {
                $0.id != -1
            }
            self.achievements = filtered
            getCategories()
            }
        }
    
    func getCategories() {
        let challengeRef = FirebaseManager.shared.firestore.collection("challenges")
        for item in achievements {
            let query = challengeRef.whereField("id", isEqualTo: item.id).limit(to: 1)
            query.getDocuments() {[self] (challengeSnapshot, error) in
                 if let error = error {
                    print("Error getting challenges: \(error)")
                 }
                let challenge = challengeSnapshot!.documents[0]
                let data = challenge.data()
                let category = self.convertToCategory(data: data)
                
                achievementsWithCategory.append(Achievement(id: item.id, score: item.score, time: item.time, userId: item.userId, date: item.date, speedBonus: item.speedBonus, category: category.name))
                print(self.achievementsWithCategory.last ?? "")
            }
        }
    }
}
    
