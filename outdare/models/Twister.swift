//
//  File.swift
//  outdare
//
//  Created by iosdev on 18.4.2022.
//

import Foundation

/// Contains the data for a game of tongue twister, basically a set of tongue twister texts.
struct Twister {
    var id: Int = 0
    let difficulty: ChallengeDifficulty
    let data: [TwisterData]
}

extension Twister {
    static let sample = [
        Twister(difficulty: .easy, data: TwisterData.sample)
    ]
}
