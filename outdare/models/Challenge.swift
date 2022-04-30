//
//  Challenge.swift
//  quiz
//
//  Created by iosdev on 2.4.2022.
//

import Foundation
import CoreLocation

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

enum ChallengeCategory: String {
    case quiz = "quiz", twister = "twister", string = "stringGame", lyrics = "lyrics"
}

enum ChallengeDifficulty: String {
    case easy, medium, hard
}

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
//extension Challenge {
//    static let sample: [Challenge] = [
//        Challenge(id: 1, challengeId: 1, name: "Quiz", difficulty: "easy", category: "quiz", description: "Answer these 5 super easy geography questions. You have 10 seconds per question.", icon: "questionmark.circle", coordinates: (0,0))
//    ]
//}
