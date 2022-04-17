//
//  LyricsChallenge.swift
//  outdare
//
//  Created by iosdev on 12.4.2022.
//

import SwiftUI

struct LyricsData {
    let timeLimit: Int
    let artist: String
    let title: String
    var lyrics: String
    let missingWords: String
    var missingWordsArray: [String] {
        missingWords.components(separatedBy: " ")
    }
    
    enum MyError: Error {
        case runtimeError(String)
    }
    
    private func wordsInRightOrder(array1: [String], array2: [String]) -> Int {
        if array1 == array2 {
            return array1.count
        } else {
            var sameOrder: [String] = []
            for i in array1.indices {
                if array1[i] == array2[i] {
                    sameOrder.append(array1[i])
                }
            }
            return sameOrder.count
        }
    }
    
    mutating func toMultiLine() {
        if lyrics.contains("\\n") {
            lyrics = lyrics.replacingOccurrences(of: "\\n", with: "\n")
        }
    }

    func checkAns(ans: String) -> LyricsResult {
        let ans = ans.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "’", with: "'")
        let ansArray = ans.components(separatedBy: " ")
        var correctArrayCopy = missingWordsArray
        let correctWordsCount = missingWordsArray.count
        let partial = 0.5
        let malus = 0.2
        
        print(ans, missingWords.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
        
        if ans == missingWords.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
            print("Perfect match", "\(ansArray.count)/\(correctWordsCount)")
            return LyricsResult(matchStatus: "Perfect match 🔥", score: Double(ansArray.count), total: correctWordsCount)
        }
        
        if ans.isEmpty {
            print("No answer", "0/\(correctWordsCount)")
            return LyricsResult(matchStatus: "No answer 🧐", score: 0.0, total: correctWordsCount)
        }
        
        var matching: [String] = []
        var wrong: [String] = []
        ansArray.forEach { word in
            if correctArrayCopy.contains(word) {
                matching.append(word)
                if let index = correctArrayCopy.firstIndex(of: word) {
                    correctArrayCopy.remove(at: index)
                }
            } else {
                wrong.append(word)
            }
        }
        let matchingOrdered = missingWordsArray.filter {matching.contains($0)}
        
        print(matching, matchingOrdered)
        
        let perfectResidualMatch = (matching == matchingOrdered)
        
        if wrong == ansArray {
            print("No match 😕", "0/\(correctWordsCount)")
            return LyricsResult(matchStatus: "No match 😕", score: 0.0, total: correctWordsCount)
        }
        
        if perfectResidualMatch && wrong.isEmpty {
            print("Partial match (no incorrect words)", "\(matching.count)/\(correctWordsCount)")
            return LyricsResult(matchStatus: "Partial match!", comment: "no incorrect words", score: Double(matching.count), total: correctWordsCount)
        }
        
        if perfectResidualMatch && !wrong.isEmpty {
            let score = max(Double(matching.count) - Double(wrong.count) * malus, 0)
            print("Partial match! (some incorrect words)", "\(score)/\(correctWordsCount)")
            return LyricsResult(matchStatus: "Partial match!", comment: "some incorrect words", score: score, total: correctWordsCount)
        }
        
        if !perfectResidualMatch && wrong.isEmpty {
            let exactMatchNum = wordsInRightOrder(array1: matching, array2: matchingOrdered)
            let score = Double(exactMatchNum) + Double(matching.count - exactMatchNum) * partial
            print("Partial match! (wrong order)", "\(score)/\(correctWordsCount)")
            return LyricsResult(matchStatus: "Partial match", comment: "wrong order", score: score, total: correctWordsCount)
        }
        
        let exactMatchNum = wordsInRightOrder(array1: matching, array2: matchingOrdered)
        let score = max(Double(exactMatchNum) - Double(wrong.count) * malus + Double(matching.count - exactMatchNum) * partial, 0)
        print("Partial match! (wrong order and some mistakes)", "\(score)/\(correctWordsCount)")
        return LyricsResult(matchStatus: "Partial match", comment: "wrong order and some mistakes", score: score, total: correctWordsCount)
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

struct LyricsResult {
    let matchStatus: String
    var comment: String = ""
    let score: Double
    let total: Int
}
