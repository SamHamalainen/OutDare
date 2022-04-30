//
//  TwisterGame.swift
//  outdare
//
//  Created by iosdev on 25.4.2022.
//

import Foundation

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
    
    func gatherData() {
        noPunctuation = arrayWithoutPunctuation()
        textArray = data[index].textArray
        timeLimit = data[index].timeLimit
    }
    
    func arrayWithoutPunctuation() -> [String] {
        let string = data[index].text.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "?", with: "").replacingOccurrences(of: "!", with: "")
        return string.components(separatedBy: " ")
    }
    
    func reset() {
        wordIndex = 0
        matchingIndices = []
        mistakes = 0
    }
    
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
    
    func checkWord(word: String) {
        if match(ref: noPunctuation[wordIndex].lowercased(), str: word.lowercased(), threshold: 0.5) {
            matchingIndices.append(wordIndex)
            wordIndex += 1
        } else {
            mistakes += 1
        }
    }
    
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
