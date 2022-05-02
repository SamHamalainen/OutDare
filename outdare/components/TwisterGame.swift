//
//  TwisterGame.swift
//  outdare
//
//  Created by iosdev on 25.4.2022.
//

import Foundation

/// Contains the logic behind the Tongue Twister game.
///
/// Provides a tongue twister which the user has to pronounce as accurately as possible and as fast as possible.
class TwisterGame: ObservableObject {
    var twister: Twister    
    @Published var index: Int = 0
    @Published var results: [ResultItem] = []
    @Published var resultString = ""
    @Published var correct = false
    @Published var wordIndex = 0
    @Published var matchingIndices: [Int] = []
    @Published var mistakes = 0
    @Published var noPunctuation: [String] = []
    @Published var textArray: [String] = []
    @Published var message = ""
    @Published var timeLimit = 0
    @Published var over = false
    
    var isCompleted: Bool {
        matchingIndices.count == textArray.count
    }
    
    // Variables that determine the scoring scheme
    let flawlessBonus = 1.5
    let mistakePenalty = 0.1
    
    var data: [TwisterData] {
        return twister.data
    }
    
    var length: Int {
        return data.count
    }
    
    var difficulty: ChallengeDifficulty {
        return twister.difficulty
    }
    
    init(twister: Twister) {
        self.twister = twister
        gatherData()
    }
    
    /// Gathers all the data needed to play
    func gatherData() {
        noPunctuation = arrayWithoutPunctuation()
        textArray = data[index].textArray
        timeLimit = data[index].timeLimit
    }
    
    /// Returns an array of strings without any punctuation to facilitate the comparison of the user's to the correct words
    func arrayWithoutPunctuation() -> [String] {
        let string = data[index].text.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "?", with: "").replacingOccurrences(of: "!", with: "")
        return string.components(separatedBy: " ")
    }
    
    func reset() {
        wordIndex = 0
        matchingIndices = []
        mistakes = 0
    }
    
    /// Compares the similitude of two strings
    ///
    /// A rating is calculated according to the number of letters they have in common and a threshold determines if rating is high enough.
    ///
    /// - Parameters:
    ///     - ref: The string to compared against
    ///     - str: The string to compare to the reference
    ///     - threshold: The threshold according to which words are similar enough
    ///
    /// - Returns: True if the words are similar enough, false otherwise
    func match(ref: String, str: String, threshold: Double) -> Bool {
        var matching = Array(str.filter {ref.contains($0)})
        var refArray = Array(ref)
        let total = ref.count
        var count = 0
        
        if matching.count == 0 {return false}
        
        if matching.count == total {return true}
        
        repeat {
            if refArray.contains(matching[0]) {
                count += 1
                if let index = refArray.firstIndex(of: matching[0]) {
                    refArray.remove(at: index)
                }
            }
            matching.remove(at: 0)
        } while matching.count != 0
                    
        let match = Double(count) / Double(total)
        
        if match >= threshold {return true}
        
        return false
    }
    
    /// Checks if the words are similar enough then add the index of the previously matched word to an array that keeps track of the words already pronounced. Mistakes are counted as well.
    ///
    /// - Parameters:
    ///     - ans: The input provided by the user
    func checkWord(word: String) {
        if match(ref: noPunctuation[wordIndex].lowercased(), str: word.lowercased(), threshold: 0.5) {
            matchingIndices.append(wordIndex)
            wordIndex += 1
        } else {
            mistakes += 1
        }
    }
    
    /// Scores the user's input according to the number of correct words and mistakes.
    ///
    /// Since Speech Recognition is not perfect (e.g a word like "which" sounds the same as "witch"), the game allows mistakes while still giving full points. A feedback is given to the user and the results are logged into an array of ResultItems.
    func makeResult() {
        print(mistakes)
        let maxPerQ = Double(getPoints(difficulty: difficulty)) / Double(length)
        let total = Double(textArray.count)
        
        if mistakes == 0 && isCompleted {
            message = "Flawless 🤩"
            let resultString = "Flawless (bonus)"
            let score = maxPerQ * flawlessBonus
            results.append(ResultItem(text: resultString, score: score))
            return
        }
        
        if matchingIndices.isEmpty {
            message = "No input 🧐"
            let resultString = "No input"
            let score = 0.0
            results.append(ResultItem(text: resultString, score: score))
            return
        }
        
        if mistakes == 0 && !isCompleted {
            message = "Incomplete!"
            let resultString = "Incomplete"
            let completionRatio = Double(matchingIndices.count) / total
            let score = maxPerQ * completionRatio
            results.append(ResultItem(text: resultString, score: score))
            return
        }
        
        let completion = matchingIndices.count
        
        var score = 0.0
        var resultString = ""
        
        let points = (Double(completion) / total) - (Double(mistakes) * mistakePenalty)/total
        
        print(points)
        
        if points > 0.9 {
            score = maxPerQ
            message = "Excellent ⭐️"
            resultString = "Excellent"
        } else if points > 0.7 {
            score = maxPerQ * 0.8
            message = "Good 👍"
            resultString = "Good"
        } else {
            score = maxPerQ * (points + 0.1)
            message = "Nice try 🤙"
            resultString = "Nice try"
        }
        
        results.append(ResultItem(text: resultString, score: score))
    }
    
    /// Ends the game if the last tongue twister has been pronounced or the time is over. Sets up the next tongue twister otherwise.
    func next() {
        if index < data.count - 1 {
            index += 1
            reset()
            gatherData()
        } else {
            over = true
        }
    }
}
