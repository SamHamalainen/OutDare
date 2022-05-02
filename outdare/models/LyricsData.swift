//
//  LyricsChallenge.swift
//  outdare
//
//  Created by iosdev on 12.4.2022.
//

import SwiftUI

/// Data for one round of a game of finish the lyrics
struct LyricsData {
    let timeLimit: Int
    let artist: String
    let title: String
    var lyrics: String
    let missingWords: String
    
    /// Transforms a string into a multiline string. When stored in Firestore, a second "\" is added automatically in front of a line break, which needs to be removed
    mutating func toMultiLine() {
        if lyrics.contains("\\n") {
            lyrics = lyrics.replacingOccurrences(of: "\\n", with: "\n")
        }
    }

}

extension LyricsData {
    static let sample = [
        LyricsData(timeLimit: 20, artist: "Bon Jovi", title: "Livin' On a Prayer",
                   lyrics: """
                    Woah, we're half way there
                    Woah, livin' on a prayer
                    Take my hand, we'll ___
                    Woah, livin' on a prayer
                    """,
                   missingWords: "make it I swear"),
        LyricsData(timeLimit: 20, artist: "Lil Nas X", title: "Old Town Road",
                   lyrics: """
                    Yeah, I'm gonna take my horse
                    To the old town road
                    I'm gonna ride 'til ___
                    """,
                   missingWords: "I can't no more"),
        LyricsData(timeLimit: 20, artist: "Abba", title: "Dancing Queen",
                   lyrics: """
                    You are the dancing queen
                    Young and sweet
                    Only seventeen
                    Dancing queen
                    Feel the beat ___, oh yeah
                    """,
                   missingWords: "from the tambourine"),
        
    ]
}
