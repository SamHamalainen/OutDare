//
//  LeaderboardCard.swift
//  outdare
//
//  Created by Jasmin Partanen on 5.4.2022.
//

import Foundation
import SwiftUI

// Hard coded data for leaderboard
struct User: Hashable, Codable, Identifiable {
    var id: Int
    var username: String
    var score: Int
    var goneUp: Bool
    var profilePicture: String
}

