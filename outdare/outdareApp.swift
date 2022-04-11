//
//  outdareApp.swift
//  outdare
//
//  Created by Jasmin Partanen on 4.4.2022.
//

import SwiftUI
import Firebase

@main
struct outdareApp: App {
    init() {
        FirebaseApp.configure()
    }
    @StateObject private var modelData = LeaderboardModel()
    
    
    var body: some Scene {
        WindowGroup {
            // ContentView()
            MainView()
        }
    }
}
