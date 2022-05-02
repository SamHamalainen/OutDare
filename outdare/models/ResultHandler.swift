//
//  ResultHandler.swift
//  outdare
//
//  Created by iosdev on 24.4.2022.
//

import Foundation
import SwiftUI

/// Contains all the results after completing a challenge and enables to push those results in Firestore.
///
/// Also serves as a struct to pass result data from a challenge view to a challenge completed view
struct ResultHandler {
    let dao = ChallengeDAO()
    var userId: String = ""
    var challengeId: Int = 0
    var results: [ResultItem] = []
    var time: Int? = nil
    let speedBonus = 1.2
    var score: Int {
        var score = results.map {$0.score}.reduce(0.0, +)
        if gotSpeedBonus() == true {
            score *= speedBonus
        }
        return Int(score)
    }
    var maxTime: Int? = nil
    
    /// Gives the score a bonus if the challenge was completed in less than half of the maximum given time
    func gotSpeedBonus() -> Bool? {
        if let time = time, let maxTime = maxTime {
            return time < maxTime/2
        } else {
            return nil
        }
    }
    
    /// Adds an attempt (= results to a challenge) to firestore
    func pushToDB() {
        dao.addAttempt(attempt: Attempt(userId: userId, challengeId: challengeId, score: Int(score), time: time, speedBonus: gotSpeedBonus()))
    }
}
