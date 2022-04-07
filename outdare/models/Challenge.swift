//
//  Challenge.swift
//  quiz
//
//  Created by iosdev on 2.4.2022.
//

import Foundation

struct Challenge {
    let id: Int
    let challengeId: Int
    let name: String
    let difficulty: String
    var points: Int {
        switch difficulty {
        case "easy":
           return 20
        case "medium":
           return 50
        default:
           return 100
        }
    }
    let category: String
    let description: String
    let logoName: String
    let coordinates: (Double, Double)
}

extension Challenge {
    static let sample: [Challenge] = [
        Challenge(id: 1, challengeId: 1, name: "Quiz", difficulty: "easy", category: "quiz", description: "Answer these 5 super easy geography questions. You have 10 seconds per question.", logoName: "questionmark.circle", coordinates: (0,0))
    ]
}
