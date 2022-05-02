//
//  Attempt.swift
//  outdare
//
//  Created by iosdev on 7.4.2022.
//

import Foundation

/// Contains all the information needed to record the results of a challenge to Firestore
struct Attempt {
    var userId = ""
    let challengeId: Int
    let score: Int
    let time: Int?
    var speedBonus: Bool?
    
    func toDB() -> [String:Any] {
        return [
            "userId": userId,
            "challengeId": challengeId,
            "score": score,
            "time": time as Any,
            "speedBonus": speedBonus as Any
        ]
    }
}
