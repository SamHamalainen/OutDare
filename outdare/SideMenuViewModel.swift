//
//  SideMenuViewModel.swift
//  outdare
//
//  Created by iosdev on 6.4.2022.
//

import Foundation
import SwiftUI

enum SideMenuViewModel: Int, CaseIterable {
    case map
    case leaderboard
    case profile
    
    var title: String {
        switch self {
            case .map: return "Map"
            case .leaderboard: return "Leaderboard"
            case .profile: return "Profile"
        }
    }
    
    var imageName: String {
        switch self {
            case .map: return "map"
            case .leaderboard: return "chart.bar"
            case .profile: return "person"
        }
    }
    
    @ViewBuilder func getView() -> some View {
        switch self {
            case .map: MapView()
            case .leaderboard: Leaderboard(users: LeaderboardCard.userData)
            case .profile: ProfileView()
        }
    }
}

