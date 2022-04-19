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
    var icon: String {
        switch category {
        case "quiz":
           return "quiz"
        case "tongue":
           return "tongueTwister"
        case "lyrics":
            return "singing"
        default:
           return "quiz"
        }
    }
    let coordinates: CLLocationCoordinate2D
}

//extension Challenge {
//    static let sample: [Challenge] = [
//        Challenge(id: 1, challengeId: 1, name: "Quiz", difficulty: "easy", category: "quiz", description: "Answer these 5 super easy geography questions. You have 10 seconds per question.", icon: "questionmark.circle", coordinates: (0,0))
//    ]
//}
