//  Color.swift
//  outdare
//  Created by Jasmin Partanen on 4.4.2022.
//  Description: Initiating application color theme

import Foundation
import SwiftUI

// App color theme
extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    let background = Color("Background")
    let background2 = Color("Background2")
    let backgroundOverlay = Color("BackgroundOverlay")
    let button = Color("Button")
    let difficultyEasy = Color("DifficultyEasy")
    let difficultyMedium = Color("DifficultyMedium")
    let difficultyHard = Color("DifficultyHard")
    let icon = Color("Icon")
    let rankingDown = Color("RankingDown")
    let rankingUp = Color("RankingUp")
    let stroke = Color("Stroke")
    let textDark = Color("TextDark")
    let textLight = Color("TextLight")
    let transparent = Color("Transparent")
}
