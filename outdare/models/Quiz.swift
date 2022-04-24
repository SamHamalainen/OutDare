//
//  Quiz.swift
//  quiz
//
//  Created by iosdev on 3.4.2022.
//

import Foundation

struct Quiz {
    let id: Int
    let timePerQuestion: Double
    let data: [QuizData]
    let difficulty: String
}

extension Quiz {
    static let sample = [
        Quiz(id: 1, timePerQuestion: 10.0, data: QuizData.sample, difficulty: "easy")
    ]
}
