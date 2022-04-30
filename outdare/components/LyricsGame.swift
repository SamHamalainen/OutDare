//
//  LyricsGame.swift
//  outdare
//
//  Created by iosdev on 25.4.2022.
//

import Foundation

class LyricsGame: ObservableObject {
    let lyricsChallenge: Lyrics
    @Published var index: Int = 0
    @Published var results: [ResultItem] = []
    @Published var lyrics = ""
    @Published var missingWords: String = ""
    @Published var missingWordsArray: [String] = []
    @Published var timeLimit: Int? = nil
    @Published var artist: String? = nil
    @Published var title: String? = nil
    @Published var correct: Bool? = nil
    @Published var resultString = ""
    @Published var missingPart: String? = nil
    @Published var over = false
    
    var data: [LyricsData] {
        return lyricsChallenge.data
    }
    var length: Int {
        return data.count
    }
    
    var difficulty: ChallengeDifficulty {
        return lyricsChallenge.difficulty
    }
    
    init(lyricsChallenge: Lyrics) {
        self.lyricsChallenge = lyricsChallenge
        gatherData()
    }
    
    func gatherData() {
        lyrics = data[index].lyrics
        missingWords = data[index].missingWords
        missingWordsArray = missingWords.components(separatedBy: " ")
        timeLimit = data[index].timeLimit
        artist = data[index].artist
        title = data[index].title
        missingPart = getHiddenWords()
    }
    
    func getHiddenWords() -> String {
        var string = ""
        for (index, word) in missingWordsArray.enumerated() {
            let isLast = (index == missingWordsArray.count - 1)
            string += (String(repeating: "_", count: word.count))
            string += (isLast) ? "" : " "
        }
        return string
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
    
    func reset() {
        correct = nil
        resultString = ""
    }
    
    func next() {
        if index < lyricsChallenge.data.count - 1 {
            index += 1
            reset()
            gatherData()
        } else {
            over = true
        }
    }
    
    func checkAns(ans: String) {
        missingPart = missingWords
        let ans = ans.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "’", with: "'")
        let ansArray = ans.components(separatedBy: " ")
        var correctArrayCopy = missingWordsArray
        let correctWordsCount = missingWordsArray.count
        let partial = 0.5
        let malus = 0.2
        let maxPerQ = Double(getPoints(difficulty: difficulty)) / Double(length)
        
        print(ans, missingWords.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
        
        if ans == missingWords.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
            print("Perfect match", "\(ansArray.count)/\(correctWordsCount)")
            correct = true
            resultString = "Perfect match 🔥"
            results.append(ResultItem(text: "Perfect match", score: maxPerQ))
            return
        }
        correct = false
        if ans.isEmpty {
            print("No answer", "0/\(correctWordsCount)")
            resultString = "No answer 🧐"
            results.append(ResultItem(text: "No answer", score: 0.0))
            return
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
            resultString = "No match 😕"
            results.append(ResultItem(text: "No match", score: 0.0))
            return
        }
        
        if perfectResidualMatch && wrong.isEmpty {
            print("Partial match (incomplete)", "\(matching.count)/\(correctWordsCount)")
            resultString = "Partial match!"
            results.append(ResultItem(text: "Partial match! (incomplete)", score: 0.0))
            return
        }
        
        if perfectResidualMatch && !wrong.isEmpty {
            let score = max(Double(matching.count) - Double(wrong.count) * malus, 0)
            let ratio = score/Double(correctWordsCount)
            print("Partial match! (some incorrect words)", "\(score)/\(correctWordsCount)")
            results.append(ResultItem(text: "Partial match! (wrong words)", score: maxPerQ * ratio))
            return
        }
        
        if !perfectResidualMatch && wrong.isEmpty {
            let exactMatchNum = wordsInRightOrder(array1: matching, array2: matchingOrdered)
            let score = Double(exactMatchNum) + Double(matching.count - exactMatchNum) * partial
            let ratio = score/Double(correctWordsCount)
            print("Partial match! (wrong order)", "\(score)/\(correctWordsCount)")
            results.append(ResultItem(text: "Partial match! (wrong order)", score: maxPerQ * ratio))
            return
        }
        
        let exactMatchNum = wordsInRightOrder(array1: matching, array2: matchingOrdered)
        let score = max(Double(exactMatchNum) - Double(wrong.count) * malus + Double(matching.count - exactMatchNum) * partial, 0)
        let ratio = score/Double(correctWordsCount)
        print("Partial match! (wrong order and some mistakes)", "\(score)/\(correctWordsCount)")
        results.append(ResultItem(text: "Partial match! (wrong order and words)", score: maxPerQ * ratio))
    }
}
