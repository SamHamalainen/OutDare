//
//  outdareApp.swift
//  outdare
//
//  Created by Jasmin Partanen on 4.4.2022.
//

import SwiftUI

@main
struct outdareApp: App {
    @StateObject private var modelData = LeaderboardModel()
    
    
    var body: some Scene {
        WindowGroup {
            Leaderboard()
                .environmentObject(modelData)
        }
    }
}
