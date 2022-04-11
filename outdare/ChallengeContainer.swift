//
//  ChallengeContainer.swift
//  quiz
//
//  Created by iosdev on 4.4.2022.
//

import SwiftUI
import CoreLocation

struct ChallengeContainer: View {
    let challenge: Challenge
    let notifyParent2: () -> Void
    @State var challengeState = "awaiting"
    @State var score = 0
    @State var time = 0.0
    
    @StateObject var dao = ChallengeDAO()
    
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
                ChallengeDetailedPreview(challenge: challenge, notifyParent2: notifyParent2, setState: changeState)
                    .onAppear() {
                        dao.getQuiz(id: challenge.challengeId)
                    }
            case "playing":
                if let quiz = dao.quiz {
                    QuizView(quiz: quiz, setState: changeState, setResult: setScoreTime)
                }
            default:
                ChallengeCompleted(score: score, time: time)
            }
        }
    }
}

struct ChallengeContainer_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeContainer(challenge: Challenge(id: 1, challengeId: 1, name: "quizzz", difficulty: "easy", category: "quiz", description: "Answer these 5 super easy questions you have 10 seconds per question.", coordinates: CLLocationCoordinate2D(latitude: 60.224810974873215, longitude: 24.75657413146672)), notifyParent2: {})
    }
}
