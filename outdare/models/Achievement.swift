//
//  Achievement.swift
//  outdare
//
//  Created by Jasmin Partanen on 26.4.2022.
//
import Foundation
import UIKit
import SwiftUI


struct Achievement: Identifiable, Hashable {
    var id, score, time, userId: Int
    var date: Date
    var speedBonus: Bool
    var category: String
}

struct Category {
    var name: String
}
