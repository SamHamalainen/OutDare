//
//  ChallengeContainer.swift
//  quiz
//
//  Created by iosdev on 4.4.2022.
//

import SwiftUI

struct ChallengeContainer: View {
    @State var challengeState = "awaiting"
    @State var score = 0
    @State var time = 0.0
    func setScoreTime(scoreTime: (Int, Double)) -> Void {
        score = scoreTime.0
        time = scoreTime.1
    }
    func changeState(newState: String) {
        challengeState = newState
    }
    var body: some View {
        Group {
            switch challengeState {
            case "awaiting":
                ChallengeDetailedPreview(challenge: Challenge.sample[0], setState: changeState)
            case "playing":
                QuizView(quiz: Quiz.sample[0], setState: changeState, setResult: setScoreTime)
            default:
                ChallengeCompleted(score: score, time: time)
            }
        }
    }
}

struct ChallengeContainer_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeContainer()
    }
}
