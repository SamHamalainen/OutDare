//
//  TriviaApiDAO.swift
//  outdare
//
//  Created by iosdev on 28.4.2022.
//

import Foundation
import HTMLEntities
import Combine

//[{"id":9,"name":"General Knowledge"},{"id":10,"name":"Entertainment: Books"},{"id":11,"name":"Entertainment: Film"},{"id":12,"name":"Entertainment: Music"},{"id":13,"name":"Entertainment: Musicals & Theatres"},{"id":14,"name":"Entertainment: Television"},{"id":15,"name":"Entertainment: Video Games"},{"id":16,"name":"Entertainment: Board Games"},{"id":17,"name":"Science & Nature"},{"id":18,"name":"Science: Computers"},{"id":19,"name":"Science: Mathematics"},{"id":20,"name":"Mythology"},{"id":21,"name":"Sports"},{"id":22,"name":"Geography"},{"id":23,"name":"History"},{"id":24,"name":"Politics"},{"id":25,"name":"Art"},{"id":26,"name":"Celebrities"},{"id":27,"name":"Animals"},{"id":28,"name":"Vehicles"},{"id":29,"name":"Entertainment: Comics"},{"id":30,"name":"Science: Gadgets"},{"id":31,"name":"Entertainment: Japanese Anime & Manga"},{"id":32,"name":"Entertainment: Cartoon & Animations"}]

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

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

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
        
    func formatForFB(triviaQuestions: [TriviaQuestion]) -> [String:Any] {
        let difficulty = triviaQuestions[0].difficulty
        let category = triviaQuestions[0].category
        let questions = triviaQuestions.map {$0.question}
        let correctAnswers = triviaQuestions.map {$0.correct_answer}
        let answers = triviaQuestions.map {$0.getAllAnswers()}
        return [
            "difficulty": difficulty,
            "category": category,
            "questions": questions,
            "correctAns": correctAnswers,
            "answers": answers
        ]
    }
    
//    func addToFB(triviaQuestions: [TriviaQuestion], latitude: Int, longitude: Int) {
//        let arrays = triviaQuestions.chunked(into: 5)
//        for arr in arrays {
//            challengeDao.addQuiz(triviaQuestions: arr)
//        }
//    }
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
