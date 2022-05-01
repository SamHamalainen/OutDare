//  UserViewModel.swift
//  outdare
//  Created by Jasmin Partanen on 13.4.2022.
//  Description: Working with user and firebase

import Foundation
import SDWebImageSwiftUI
import Firebase
import SwiftUI


// User item in the leaderboard list
struct RankingItem: Identifiable {
    var id: UUID = UUID()
    var rank: Int
    var user: CurrentUser
    
    init(_ rank: Int, _ user: CurrentUser) {
        self.rank = rank
        self.user = user
    }
}

class UserViewModel: ObservableObject {
    @Published var errorMessage = ""
    
    // Logged in user
    @Published var currentUser: CurrentUser?
    
    // All users in the users db
    private var users: [CurrentUser] = []
    private var usersWithScores: [CurrentUser] = []
    @Published var usersSorted: [CurrentUser] = []
    @Published var rankingSorted: [RankingItem] = []
    
    // Users achievements
    private var achievements: [Achievement] = []
    @Published var achievementsWithCategory: [Achievement] = []

    
    init() {
        fetchCurrentUser()
        fetchAllUsers()
    }

    // Common function to convert userData from firebase to CurrentUser struct
    func convertToUser(data: [String:Any]) -> CurrentUser {
        let id = data ["userId"] as? String ?? ""
        let username = data["username"] as? String ?? ""
        let location = data["location"] as? String ?? ""
        let email = data["email"] as? String ?? ""
        let profilePicture = data["profilePicture"] as? String ?? ""
        
        return CurrentUser(id: id, username: username, location: location, email: email, profilePicture: profilePicture, score: 0)
    }
    
    // function to convert achievement from firebase to Achievement struct
    func convertToAchievement(data: [String:Any]) -> Achievement {
        let id = data ["challengeId"] as? Int ?? 0
        let score = data["score"] as? Int ?? 0
        let time = data["time"] as? Int ?? 0
        let userId = data["userId"] as? Int ?? 0
        let date = data["date"] as? Date ?? Date()
        let speedBonus = data["speedBonus"] as? Bool ?? false
        return Achievement(id: id, score: score, time: time, userId: userId, date: date, speedBonus: speedBonus, category: "")
    }
    
    // function to convert category from firebase to category struct
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
    
    // Fetching all user from firestore
    private func fetchAllUsers() {
        let userRef = FirebaseManager.shared.firestore.collection("users")
        userRef.getDocuments() { [self] (querySnapshot, error) in
            if let error = error {
                self.errorMessage = "Failed to fetch users: \(error)"
                print("Failed to fetch users: \(error)")
                return
            }
            for document in querySnapshot!.documents {
                let data = document.data()
                let useruid = document.documentID
                let user = self.convertToUser(data: data)
                users.append(CurrentUser(id: useruid, username: user.username, location: user.location, email: user.email, profilePicture: user.profilePicture, score: user.score))
            }
            self.errorMessage = "Successfully fetched users"
            fetchAllScores()
        }
    }
    
    // Fetching current user achievements
    func fetchAllScores() {
        let attemptRef = FirebaseManager.shared.firestore.collection("attempts")
        for user in users {
            let query = attemptRef.whereField("userId", isEqualTo: user.id)
            query.getDocuments() {[self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting user attempts: \(err)")
                }
                var scores: [Int] = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let score = data["score"] as? Int ?? 0
                        print("scoreInLogged: \(score)")
                        scores.append(score)
                    }
                let userScore = scores.reduce(0, +)
                
                usersWithScores.append(CurrentUser(id: user.id, username: user.username, location: user.location, email: user.email, profilePicture: user.profilePicture, score: userScore))
                
                self.usersSorted = usersWithScores.sorted(by: { $0.score > $1.score })
                let rankings = getUserRanking(users: usersSorted).sorted(by: {$0.rank <= $1.rank})
                self.rankingSorted = rankings
        }
    }
}
    
    // Get user ranking number
    func getUserRanking(users: [CurrentUser]) -> [RankingItem] {
        let sorted = users.sorted(by: {$0.score > $1.score})
        var previousScore = sorted[0].score
        var grouped: [[CurrentUser]] = Array(repeating: [], count: sorted.count)
        grouped[0].append(sorted[0])
        var arrayIndex = 0
        
        for user in self.usersSorted.dropFirst() {
               if user.score == previousScore {
                   grouped[arrayIndex].append(user)
               } else {
                   arrayIndex += 1
                   grouped[arrayIndex].append(user)
                   previousScore = user.score
               }
           }
        let emptyRemoved = grouped.filter {!$0.isEmpty}
        var ranking: [Int:[CurrentUser]] = [:]
        var rank = 1
        
        for userArray in emptyRemoved {
               ranking[rank] = userArray
               rank += userArray.count
           }
        var pairs: [RankingItem] = []
        
        for rank in ranking.keys {
            if let users = ranking[rank] {
                for user in users {
                    pairs.append(RankingItem(rank, user))
                }
            }
        }
        return pairs
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
    
    // Fetching category names for the challenges user has completed
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
            }
        }
    }
}
    
