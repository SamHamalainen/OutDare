//
//  ChallengeTimer.swift
//  quiz
//
//  Created by iosdev on 3.4.2022.
//

import SwiftUI
import Combine

struct ChallengeTimerBar: View {
    @ObservedObject var timer: ChallengeTimer
    
    var body: some View {
        VStack {
            ProgressView(value: timer.count, total: timer.timeLimit)
                .padding()
                .tint(Color.theme.icon)
        }        
    }
}

//struct ChallengeTimer_Previews: PreviewProvider {
//    static var previews: some View {
//        ChallengeTimerBar(timeLimit: 10.0, label: "Time left...")
//    }
//}
