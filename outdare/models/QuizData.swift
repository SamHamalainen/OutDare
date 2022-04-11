//
//  QuizData.swift
//  quiz
//
//  Created by iosdev on 3.4.2022.
//

import Foundation

struct QuizData {
    let question: String
    let answers: [String]
    let correctAns: String
}

extension QuizData {
    static let sample = [
        QuizData(question: "What is the capital of Germany?", answers: ["Frankfurt", "Zürich", "Berlin", "München"], correctAns: "Berlin"),
        QuizData(question: "Where is Thailand?", answers: ["South East Asia", "West Asia", "Middle East", "Africa"], correctAns: "South East Asia" ),
        QuizData(question: "Where is Guatemala?", answers: ["South America", "North America", "Africa", "Europe"], correctAns: "North America"),
        QuizData(question: "What is the capital of Croatia?", answers: ["Zagreb", "Belgrade", "Sofia", "Split"], correctAns: "Zagreb"),
        QuizData(question: "What is the name of the ocean between Europe and America?", answers: ["Indian", "Pacific", "Atlantic", "Arctic"], correctAns: "Atlantic")
    ]
}
