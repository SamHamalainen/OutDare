//
//  QuizGame.swift
//  outdare
//
//  Created by iosdev on 24.4.2022.
//

import Foundation

class QuizGame: ObservableObject {
    let quiz: Quiz
    @Published var index: Int = 0
    @Published var results: [ResultItem] = []
    @Published var score = 0
    @Published var correct: Bool? = nil
    @Published var question: String? = nil
    @Published var answers: [String]? = nil
    @Published var message: String? = nil
    @Published var correctAns: String? = nil
    @Published var over = false
    var timePerQ: Int {
        return Int(quiz.timePerQuestion)
    }
    var data: [QuizData] {
        return quiz.data
    }
    var length: Int {
        return data.count
    }
    
    init(quiz: Quiz) {
        self.quiz = quiz
    }
    
    func getQuestion() {
        question = data[index].question
    }
    
    func getAnswers() {
        answers = data[index].answers
    }
    
    func getCorrectAns() {
        correctAns = data[index].correctAns
    }
    
    func reset() {
        correct = nil
        question = nil
        answers = nil
    }
    
    func checkAns(ans: String) {
        let data = quiz.data[index]
        correct = (ans == data.correctAns)
        if correct == true {
            message = "Correct 🔥"
            let score = Double(getPoints(difficulty: quiz.difficulty)) / Double(quiz.data.count)
            results.append(ResultItem(text: "Q\(index + 1): Correct", score: round(score * 10) / 10))
        } else {
            message = "Wrong answer 😕"
            results.append(ResultItem(text: "Q\(index + 1): Incorrect", score: 0.0))
        }
    }
    
    func gatherData() {
        getQuestion()
        getAnswers()
        getCorrectAns()
    }
    
    func next() {
        if index < quiz.data.count - 1 {
            reset()
            index += 1
            gatherData()
        } else {
            over = true
        }
    }
}
