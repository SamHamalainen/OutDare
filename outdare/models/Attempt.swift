//
//  Attempt.swift
//  outdare
//
//  Created by iosdev on 7.4.2022.
//

import Foundation

struct Attempt {
    let userId = 0
    let challengeId: Int
    let date: String = ""
    let score: Int
    let time: Int
    let points: Int
    
    func toDB() -> [String:Any] {
        return [
            "userId": userId,
            "challengeId": challengeId,
            "date": date,
            "score": score,
            "time": time,
            "points": points
        ]
    }
}
