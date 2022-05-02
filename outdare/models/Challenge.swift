//
//  Challenge.swift
//  quiz
//
//  Created by iosdev on 2.4.2022.
//

import Foundation
import CoreLocation

/// Contains all the data related to a challenge. ChallengeId is a bit confusing but it represents the id of the firestore document which contains the data needed for the challenges (quiz, tongue twister and finish the lyrics)
struct Challenge: Identifiable, Equatable {
    let id: Int
    let challengeId: Int
    let name: String
    let difficulty: ChallengeDifficulty
    var points: Int {
        return getPoints(difficulty: difficulty)
    }
    let category: ChallengeCategory
    let description: String
    var icon: String {
        switch category {
        case .quiz:
           return "quiz"
        case .twister:
           return "tongueTwister"
        case .string:
            return "stringGame"
        case .lyrics:
            return "lyrics"
        }
    }
    let coordinates: CLLocationCoordinate2D
}

/// Different types of challenges
enum ChallengeCategory: String {
    case quiz = "quiz", twister = "twister", string = "stringGame", lyrics = "lyrics"
}

/// Difficulty level of a challenge
enum ChallengeDifficulty: String {
    case easy, medium, hard
}

/// Returns the max points that one can earn according to the difficulty of the challenge completed
func getPoints(difficulty: ChallengeDifficulty) -> Int {
    switch difficulty {
    case .easy :
        return 20
    case .medium :
        return 40
    case .hard:
        return 50
    }
}

extension Challenge {
    static let sample: [Challenge] = [
        Challenge(id: 1, challengeId: 1, name: "Test", difficulty: .easy, category: .quiz, description: "Some description", coordinates: CLLocationCoordinate2D(latitude: 60.224810974873215, longitude: 24.75657413146672))
    ]
}
