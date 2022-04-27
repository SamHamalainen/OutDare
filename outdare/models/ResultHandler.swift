//
//  ResultHandler.swift
//  outdare
//
//  Created by iosdev on 24.4.2022.
//

import Foundation
import SwiftUI

struct ResultHandler {
    let dao = ChallengeDAO()
    let userId: Int = UserDefaults.standard.integer(forKey: "userId")
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
    
    func addResult(results: [ResultItem], time: Int? = nil, maxTime: Int? = nil) {
        
    }
    
    func gotSpeedBonus() -> Bool? {
        if let time = time, let maxTime = maxTime {
            return time < maxTime/2
        } else {
            return nil
        }
    }
    
    func makeAttempt() -> Attempt {
        return Attempt(userId: userId, challengeId: challengeId, score: Int(score), time: time, speedBonus: gotSpeedBonus())
    }
    
    func pushToDB() {
        dao.addAttempt(attempt: makeAttempt())
    }
}
