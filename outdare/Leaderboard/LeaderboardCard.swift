//
//  LeaderboardCard.swift
//  outdare
//
//  Created by Jasmin Partanen on 5.4.2022.
//

import Foundation

// Hard coded data for leaderboard
struct LeaderboardCard: Identifiable {
    let id: UUID
    var username: String
    var score: Int
    var goneUp: Bool
    var profilePicture: String
    
    init(id: UUID = UUID(), username: String, score: Int, goneUp: Bool, profilePicture: String) {
            self.id = id
            self.username = username
            self.score = score
            self.goneUp = goneUp
            self.profilePicture = profilePicture
        }
}



extension LeaderboardCard {
    static let userData: [LeaderboardCard] = [
    LeaderboardCard(username: "IAmNewbie", score: 1340, goneUp: true, profilePicture: "https://robohash.org/etvoluptatemillum.png?size=300x300&set=set1"),
    LeaderboardCard(username: "Soronoo", score: 1256, goneUp: true, profilePicture: "https://robohash.org/rerumeumquae.png?size=300x300&set=set1"),
    LeaderboardCard(username: "HelloKitty", score: 1200, goneUp: false, profilePicture: "https://robohash.org/corporisoptioquo.png?size=300x300&set=set1"),
    LeaderboardCard(username: "IAmNewbie", score: 890, goneUp: false, profilePicture: "https://robohash.org/etvoluptatemillum.png?size=300x300&set=set1"),
    LeaderboardCard(username: "Soronoo", score: 795, goneUp: false, profilePicture: "https://robohash.org/rerumeumquae.png?size=300x300&set=set1"),
    LeaderboardCard(username: "HelloKitty", score: 794, goneUp: true, profilePicture: "https://robohash.org/corporisoptioquo.png?size=300x300&set=set1"),
    LeaderboardCard(username: "IAmNewbie", score: 567, goneUp: true, profilePicture: "https://robohash.org/etvoluptatemillum.png?size=300x300&set=set1"),
    LeaderboardCard(username: "Soronoo", score: 456, goneUp: true, profilePicture: "https://robohash.org/rerumeumquae.png?size=300x300&set=set1"),
    LeaderboardCard(username: "HelloKitty", score: 345, goneUp: false, profilePicture: "https://robohash.org/corporisoptioquo.png?size=300x300&set=set1"),
    LeaderboardCard(username: "HelloKitty", score: 234, goneUp: true, profilePicture: "https://robohash.org/corporisoptioquo.png?size=300x300&set=set1"),
    ]
}
