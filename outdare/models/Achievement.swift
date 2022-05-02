//
//  Achievement.swift
//  outdare
//
//  Created by Jasmin Partanen on 26.4.2022.
//
import Foundation
import UIKit
import SwiftUI


struct Achievement: Hashable {
    var id: Int
    var challengeId, score, time: Int
    var userId: String
    var speedBonus: Bool
    var category: String
    var difficulty: String
}

struct CategoryAndDifficulty {
    var name: String
    var difficulty: String
}
