//
//  Challenge.swift
//  quiz
//
//  Created by iosdev on 2.4.2022.
//

import Foundation

struct Challenge {
    let logoName: String
    let title: String
    let difficulty: String
    let points: Int
    let headline: String
    let instructions: String
    let timer: Int
}

extension Challenge {
    static let sample: [Challenge] = [
        Challenge(logoName: "questionmark.circle", title: "Quiz", difficulty: "Easy", points: 20, headline: "Get Ready!", instructions: "Answer these 5 super easy geography questions. You have 10 seconds per question.", timer: 3)
    ]
}
