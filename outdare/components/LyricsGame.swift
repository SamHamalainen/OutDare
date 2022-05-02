//
//  LyricsGame.swift
//  outdare
//
//  Created by iosdev on 25.4.2022.
//

import Foundation

/// Contains the logic behind the Finish the Lyrics game.
///
/// Provides the lyrics to a song with a missing part, which users have to guess. Compares their input the correct string and gives them a score according to accuracy, which is logged into an array of ResultItems.
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
    
    /// Gathers all the data necessary for the game's UI
    private func gatherData() {
        lyrics = data[index].lyrics
        missingWords = data[index].missingWords
        missingWordsArray = missingWords.components(separatedBy: " ")
        timeLimit = data[index].timeLimit
        artist = data[index].artist
        title = data[index].title
        missingPart = getHiddenWords()
    }
    
    /// Produces the string of hidden words.
    /// - Returns: A string of underscores corresponding the correct answer's word and letter count (e.g. "Livin' on a prayer" returns "______ __ _ ______")
    private func getHiddenWords() -> String {
        var string = ""
        for (index, word) in missingWordsArray.enumerated() {
            let isLast = (index == missingWordsArray.count - 1)
            string += (String(repeating: "_", count: word.count))
            string += (isLast) ? "" : " "
        }
        return string
    }
    
    /// Compares the similitude between two arrays of strings.
    ///
    /// - Parameters: Two arrays of the same size to compare
    ///
    /// - Returns: The number of item which are identical in both arrays, in terms of string and position (e.g. [a, b, c, d] and [z, b, c, h] will return "2")
    ///
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
    
    /// Resets the answer feedback to the user
    func reset() {
        correct = nil
        resultString = ""
    }
    
    /// Ends the quiz if there is no more lyrics, otherwise sets up the next lyrics.
    func next() {
        if index < lyricsChallenge.data.count - 1 {
            index += 1
            reset()
            gatherData()
        } else {
            over = true
        }
    }
    
    /// Compares the answer of the user to the correct answer. Gives a score according to accuracy.
    ///
    /// Partial points are given for correct words in the wrong order and minus points are given for incorrect words. Results are logged into a ResultItem array. Feedback to the user is updated.
    ///
    /// - Parameters:
    ///     - ans: String to be compared to the correct string
    func checkAns(ans: String) {
        missingPart = missingWords
        let ans = ans.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "’", with: "'")
        let ansArray = ans.components(separatedBy: " ")
        var correctArrayCopy = missingWordsArray
        let correctWordsCount = missingWordsArray.count
        let partial = 0.5
        let malus = 0.2
        let maxPerQ = Double(getPoints(difficulty: difficulty)) / Double(length)
                
        if ans == missingWords.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) {
            correct = true
            resultString = "Perfect match 🔥"
            results.append(ResultItem(text: "Perfect match", score: maxPerQ))
            return
        }
        correct = false
        if ans.isEmpty {
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
            resultString = "No match 😕"
            results.append(ResultItem(text: "No match", score: 0.0))
            return
        }
        
        if perfectResidualMatch && wrong.isEmpty {
            resultString = "Partial match!"
            results.append(ResultItem(text: "Partial match! (incomplete)", score: 0.0))
            return
        }
        
        if perfectResidualMatch && !wrong.isEmpty {
            let score = max(Double(matching.count) - Double(wrong.count) * malus, 0)
            let ratio = score/Double(correctWordsCount)
            resultString = "Partial match!"
            results.append(ResultItem(text: "Partial match! (wrong words)", score: maxPerQ * ratio))
            return
        }
        
        if !perfectResidualMatch && wrong.isEmpty {
            let exactMatchNum = wordsInRightOrder(array1: matching, array2: matchingOrdered)
            let score = Double(exactMatchNum) + Double(matching.count - exactMatchNum) * partial
            let ratio = score/Double(correctWordsCount)
            resultString = "Partial match!"
            results.append(ResultItem(text: "Partial match! (wrong order)", score: maxPerQ * ratio))
            return
        }
        
        let exactMatchNum = wordsInRightOrder(array1: matching, array2: matchingOrdered)
        let score = max(Double(exactMatchNum) - Double(wrong.count) * malus + Double(matching.count - exactMatchNum) * partial, 0)
        let ratio = score/Double(correctWordsCount)
        resultString = "Partial match!"
        results.append(ResultItem(text: "Partial match! (wrong order and words)", score: maxPerQ * ratio))
    }
}
