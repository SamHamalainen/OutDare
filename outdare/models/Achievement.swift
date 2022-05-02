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
    var challengeId, score, time: Int
    var userId: String
    var speedBonus: Bool
    var category: String
}

struct Category {
    var name: String
}
