//
//  TwisterData.swift
//  outdare
//
//  Created by iosdev on 18.4.2022.
//

import SwiftUI

struct TwisterData {
    let timeLimit: Int
    let text: String
    var textArray: [String] = []
    
    init(timeLimit: Int, text: String) {
        self.timeLimit = timeLimit
        self.text = text
        self.textArray = text.components(separatedBy: " ")
    }
}

extension TwisterData {
    static let sample = [
        TwisterData(timeLimit: 30, text: "If two witches were watching two watches, which witch would watch which watch?"),
        TwisterData(timeLimit: 30, text: "The big black bug bit the big black bear, but the big black bear bit the big black bug back!"),
        TwisterData(timeLimit: 30, text: "The owner of the inside inn was inside his inside inn with his inside outside his inside inn.")
    ]
}

class TwisterHandler: ObservableObject {
    var data: TwisterData = TwisterData.sample[0]
    @Published var index = 0
    @Published var matchingIndices: [Int] = []
    @Published var mistakes = 0
    var noPunctuation: [String] {
        arrayWithoutPunctuation()
    }
    
    func arrayWithoutPunctuation() -> [String] {
        let string = data.text.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "?", with: "").replacingOccurrences(of: "!", with: "")
        return string.components(separatedBy: " ")
    }
    
    func newData(newData: TwisterData) {
        self.data = newData
        reset()
    }
    
    func reset() {
        index = 0
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
        if match(ref: noPunctuation[index].lowercased(), str: word.lowercased(), threshold: 0.5) {
            matchingIndices.append(index)
            index += 1
        } else {
            mistakes += 1
        }
    }
}
