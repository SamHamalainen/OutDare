//
//  QuizGame.swift
//  outdare
//
//  Created by iosdev on 24.4.2022.
//

import Foundation

/// Contains the logic behind the Quiz game.
///
/// Provides the questions and possible answers at each round and records the results in a ResultItem array.
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

    ///Sets the current question
    func getQuestion() {
        question = data[index].question
    }
    
    ///Sets the current possible answers
    func getAnswers() {
        answers = data[index].answers
    }
    
    ///Sets the current correct question
    func getCorrectAns() {
        correctAns = data[index].correctAns
    }
    
    func reset() {
        correct = nil
        question = nil
        answers = nil
    }
    
    /// Compares a string to the correct answer string.
    ///
    /// Gives 0 for a wrong answer and ( max quiz points / number of questions ) if correct. The results are logged into an array of ResultItems
    ///
    /// - Parameters:
    ///     - ans: String to be compared to the correct answer
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
    
    /// Gathers all the data needed for the Quiz game UI
    func gatherData() {
        getQuestion()
        getAnswers()
        getCorrectAns()
    }
    
    /// Ends the game the last question has been answered. Otherwise, sets up the next question and answers
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
