//
//  Lyrics.swift
//  outdare
//
//  Created by iosdev on 14.4.2022.
//

import Foundation

/// Contains the data needed for a LyricsGame
struct Lyrics {
    var id: Int = 0
    var difficulty: ChallengeDifficulty
    let data: [LyricsData]
}

extension Lyrics {
    static let sample = [
        Lyrics(difficulty: .easy, data: LyricsData.sample)
    ]
}
