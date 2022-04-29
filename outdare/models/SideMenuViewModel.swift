//
//  SideMenuViewModel.swift
//  outdare
//
//  Created by Tatu Ihaksi on 6.4.2022.
//

import Foundation
import SwiftUI

enum SideMenuViewModel: Int, CaseIterable {
    
    case map, leaderboard, profile, quizGenerator
    
    // Sets the navigation title
    var title: String {
        switch self {
            case .map: return "Map"
            case .leaderboard: return "Leaderboard"
            case .profile: return "Profile"
            case .quizGenerator: return "Generator"
        }
    }
    
    // Icon names for the menu items
    var imageName: String {
        switch self {
            case .map: return "map"
            case .leaderboard: return "chart.bar"
            case .profile: return "person"
            case .quizGenerator: return "dice"
        }
    }
    
    // Returns the view which in the menu item will lead to
    @ViewBuilder
    func getView() -> some View {
        switch self {
            case .map: MapView()
            case .leaderboard: Leaderboard()
            case .profile: UserProfile()
            case .quizGenerator: QuizGeneratorView()
        }
    }
}

