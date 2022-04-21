//
//  ChallengeContainer.swift
//  quiz
//
//  Created by iosdev on 4.4.2022.
//

import SwiftUI
import CoreLocation
import Speech

struct ChallengeContainer: View {
    @Binding var challengeInfoOpened: Bool
    @Binding var revealedChallenge: Bool
    let challenge: Challenge
    let notifyParent2: () -> Void
    @State var challengeState = "awaiting"
    @State var score = 0.0
    @State var time = 0.0
    
    @StateObject var dao = ChallengeDAO()
    
    func setScoreTime(scoreTime: (Double, Double)) -> Void {
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
                        switch challenge.category {
                        case "quiz":
                            dao.getQuiz(id: challenge.challengeId)
                        case "lyrics":
                            dao.getLyrics(id: challenge.challengeId)
                        default:
                            return
                        }
                    }
            case "playing":
                switch challenge.category {
                case "quiz":
                    if let quiz = dao.quiz {
                        QuizView(quiz: quiz, setState: changeState, setResult: setScoreTime)
                    }
                case "lyrics":
                    if let lyrics = dao.lyrics {
                        LyricsView(lyricsChallenge: lyrics, setState: changeState, setResult: setScoreTime)
                    }
                default:
                    Text("invalid category")
                }
                
                
            default:
                ChallengeCompleted(challengeInfoOpened: $challengeInfoOpened, revealedChallenge: $revealedChallenge, score: score, time: time)
            }
        }
    }
}

//struct ChallengeContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        ChallengeContainer(challenge: Challenge(id: 1, challengeId: 1, name: "quizzz", difficulty: "easy", category: "quiz", description: "Answer these 5 super easy questions you have 10 seconds per question.", coordinates: CLLocationCoordinate2D(latitude: 60.224810974873215, longitude: 24.75657413146672)), notifyParent2: {})
//    }
//}
