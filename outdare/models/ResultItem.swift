//
//  ResultItem.swift
//  outdare
//
//  Created by iosdev on 23.4.2022.
//

import SwiftUI

/// Structure meant to record points for a challenge and facilitate their display on a ChallengeCompleted view
struct ResultItem: Hashable {
    let text: String
    var comment: String? = nil
    let score: Double
}
