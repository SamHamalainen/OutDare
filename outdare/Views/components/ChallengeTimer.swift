//
//  ChallengeTimer.swift
//  quiz
//
//  Created by iosdev on 3.4.2022.
//

import SwiftUI
import Combine

struct ChallengeTimer: View {
    let timeLimit: Double
    let label: String
    @State var timeCount = 0.0
    @State var timer: Timer? = nil
    
    var body: some View {
        VStack {
            ProgressView(label, value: timeCount, total: timeLimit)
                .padding()
                .tint(Color.gray)
        }        
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {timer in
            if timeCount < timeLimit - 0.01 {
                timeCount += 0.01
            }
            
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func restart() {
        timeCount = 0.0
        start()
    }
}

struct ChallengeTimer_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeTimer(timeLimit: 10.0, label: "Time left...")
    }
}
