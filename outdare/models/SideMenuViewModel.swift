//
//  SideMenuViewModel.swift
//  outdare
//
//  Created by Tatu Ihaksi on 6.4.2022.
//

import Foundation
import SwiftUI

enum SideMenuViewModel: Int, CaseIterable {
    
    case map, leaderboard, profile, quizGenerator, store
    
    // Sets the navigation title
    var title: LocalizedStringKey {
        switch self {
            case .map: return LocalizedStringKey("Map")
            case .leaderboard: return LocalizedStringKey("Leaderboard")
            case .profile: return LocalizedStringKey("Profile")
            case .quizGenerator: return LocalizedStringKey("Generator")
            case .store: return LocalizedStringKey("Store")
        }
    }
    
    // Icon names for the menu items
    var imageName: String {
        switch self {
            case .map: return "map"
            case .leaderboard: return "chart.bar"
            case .profile: return "person"
            case .quizGenerator: return "dice"
            case .store: return "cart"
        }
    }
}

