//
//  ChallengeTimer.swift
//  outdare
//
//  Created by iosdev on 12.4.2022.
//

import Foundation

/// Timer for the challenges. Publishes its count every 0.01 seconds and isOver = true when the timer is over.
///
/// Controls the duration of challenges and whether the user can interract with them or not (when the timer is over)
final class ChallengeTimer: ObservableObject {
    @Published var count = 0.0
    @Published var isRunning = false
    @Published var totalTime = 0.0
    @Published var isOver = false
    var timeLimit: Double = 10.0
    private var timer: Timer? = nil
    
    func setTimeLimit(limit: Double) {
        self.timeLimit = limit
    }
    
    /// Starts timer with a slight delay to account for challenge view rendering
    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
    
    /// Stops the timer by invalidating it and setting its value to nil
    func stop() {
        self.isRunning = false
        self.totalTime += count
        self.timer?.invalidate()
        self.timer = nil
    }
    
    /// Resetting count and the timer starting again
    func restart() {
        self.count = 0.0
        self.start()
    }
}
