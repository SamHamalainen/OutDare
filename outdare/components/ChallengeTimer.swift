//
//  ChallengeTimer.swift
//  outdare
//
//  Created by iosdev on 12.4.2022.
//

import Foundation

final class ChallengeTimer: ObservableObject {
    @Published var count = 0.0
    @Published var isRunning = false
    @Published var totalTime = 0.0
    @Published var isOver = false
    var timeLimit: Double = 10.0
    private var timer: Timer? = nil
    var test = ""
    
    func setTimeLimit(limit: Double) {
        self.timeLimit = limit
    }
    
    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            print("started")
            self.isRunning = true
            self.isOver = false
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {timer in
                if self.count < self.timeLimit - 0.01 {
                    self.count += 0.01
                } else {
                    self.isOver = true
                }
            }
        }
    }
    
    func stop() {
        print("stopped")
        self.isRunning = false
        self.totalTime += count
        self.timer?.invalidate()
        self.timer = nil
    }
    
    func restart() {
        self.count = 0.0
        self.start()
    }
}
