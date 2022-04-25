//
//  Attempt.swift
//  outdare
//
//  Created by iosdev on 7.4.2022.
//

import Foundation

struct Attempt {
    var userId = 0
    let challengeId: Int
    let score: Int
    let time: Int?
    var speedBonus: Bool?
    
    func toDB() -> [String:Any] {
        return [
            "userId": userId,
            "challengeId": challengeId,
            "score": score,
            "time": time ?? nil,
            "speedBonus": speedBonus ?? nil
        ]
    }
}
