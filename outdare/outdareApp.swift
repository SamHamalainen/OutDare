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
    @State var showMap = false
    
    
    var body: some Scene {
        WindowGroup {
//            if showMap {
//                MainView()
//            } else {
//                StartView(showMap: $showMap)
//            }
            QuizView(quiz: Quiz.sample[0], setState: {_ in}, setResult: {_ in})
        }
    }
}
