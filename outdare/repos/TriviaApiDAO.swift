//
//  TriviaApiDAO.swift
//  outdare
//
//  Created by iosdev on 28.4.2022.
//

import Foundation
import HTMLEntities
import Combine
import CoreLocation
import SwiftUI

class TriviaApiDao: ObservableObject {
    let challengeDao = ChallengeDAO()
    @Published var fetchedQuestions: [TriviaQuestion] = []
    @Published var loading: Bool? = nil
    let quizCategories = [
        "General Knowledge": 9,
        "Entertainment: Books": 10,
        "Entertainment: Film": 11,
        "Entertainment: Music": 12,
        "Entertainment: Musicals & Theatres": 13,
        "Entertainment: Television": 14,
        "Entertainment: Video Games": 15,
        "Entertainment: Board Games": 16,
        "Science & Nature": 17,
        "Science: Computers": 18,
        "Science: Mathematics": 19,
        "Mythology":20,
        "Sports": 21,
        "Geography": 22,
        "History": 23,
        "Politics": 24,
        "Art": 25,
        "Celebrities": 26,
        "Animals": 27,
        "Vehicles": 28,
        "Entertainment: Comics": 29,
        "Science: Gadgets": 30,
        "Entertainment: Japanese Anime & Manga": 31,
        "Entertainment: Cartoon & Animations": 32
    ]
    
    func generateQuestions(amount: Int = 10, categoryName: String, difficulty: String = "easy") {
        DispatchQueue.main.async {
            self.loading = true
        }
        let category = quizCategories[categoryName] ?? 0
        
        guard let url = URL(string: "https://opentdb.com/api.php?amount=\(amount)&category=\(category)&difficulty=\(difficulty)&type=multiple") else {
            fatalError("URL invalid")
        }
        
        let task = URLSession.shared.dataTask(with: url){
            data, response, error in
            let decoder = JSONDecoder()

            if let data = data, let string = String(data: data, encoding: .utf8){
                let json = string.components(separatedBy: "\"results\":")[1].dropLast()
//                let jsonUnencoded = String(json).htmlUnescape()
                let jsonCorrected = json
                    .replacingOccurrences(of: "&#039;", with: "'")
                    .replacingOccurrences(of: "&quot;", with: "")
                    .replacingOccurrences(of: "&eacute;", with: "é")
                    .replacingOccurrences(of: "&amp;", with: "&")
                guard let jsonData = jsonCorrected.data(using: .utf8) else {
                    return
                }
                do {
                    let tasks = try decoder.decode([TriviaQuestion].self, from: jsonData)
                    var triviaQuestions: [TriviaQuestion] = []
                    tasks.forEach {i in
                        triviaQuestions.append(i)
                    }
                    if triviaQuestions.count < amount {
                        self.generateQuestions(amount: amount - 1, categoryName: categoryName, difficulty: difficulty)
                    } else {
                        DispatchQueue.main.async {
                            self.fetchedQuestions = triviaQuestions
                            self.loading = false
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}

struct TriviaQuestion: Decodable, Hashable {
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    var incorrect_answers: [String]
    
    func getAllAnswers() -> [String] {
        var answers = incorrect_answers
        answers.append(correct_answer)
        return answers.shuffled()
    }
}

extension TriviaQuestion {
    static let sample = [
        TriviaQuestion(category: "Entertainment: Cartoon & Animations", type: "multiple", difficulty: "easy", question: "Who is the only voice actor to have a speaking part in all of the Disney Pixar feature films? ", correct_answer: "John Ratzenberger", incorrect_answers: ["Tom Hanks", "Dave Foley", "Geoffrey Rush"]),
        TriviaQuestion(category: "Entertainment: Cartoon & Animations", type: "multiple", difficulty: "easy", question: "When did the last episode of Futurama air?", correct_answer: "September 4, 2013", incorrect_answers: ["December 25, 2010", "March 28, 1999", "On Going"]),
        TriviaQuestion(category: "Entertainment: Cartoon & Animations", type: "multiple", difficulty: "easy", question: "What was the first Disney movie to use CGI?", correct_answer: "The Black Cauldron", incorrect_answers: ["Tron", "Toy Story", "Fantasia"]),
        TriviaQuestion(category: "Entertainment: Cartoon & Animations", type: "multiple", difficulty: "easy", question: "In the Pixar film, Toy Story what was the name of the child who owned the toys?", correct_answer: "Andy", incorrect_answers: ["Edward", "Danny", "Matt"]),
        TriviaQuestion(category: "Entertainment: Cartoon & Animations", type: "multiple", difficulty: "easy", question: "Who created the Cartoon Network series Regular Show?", correct_answer: "J. G. Quintel", incorrect_answers: ["Ben Bocquelet", "Pendleton Ward", "Rebecca Sugar"])
    ]
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
