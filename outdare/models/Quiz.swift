//
//  Quiz.swift
//  quiz
//
//  Created by iosdev on 3.4.2022.
//

import Foundation

struct Quiz {
    let timePerQuestion: Double
    let data: [QuizData]
}

extension Quiz {
    static let sample = [
        Quiz(timePerQuestion: 10.0, data: QuizData.sample)
    ]
}
