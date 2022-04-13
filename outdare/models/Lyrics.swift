//
//  Lyrics.swift
//  outdare
//
//  Created by iosdev on 14.4.2022.
//

import Foundation

struct Lyrics {
    var id: Int = 0
    var difficulty: String
    let data: [LyricsData]
}

extension Lyrics {
    static let sample = [
        Lyrics(difficulty: "easy", data: LyricsData.sample)
    ]
}
