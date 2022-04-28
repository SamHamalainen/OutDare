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
    let notifyParent: () -> Void
    @State var challengeState = "awaiting"
    @State var resultHandler = ResultHandler()
    @StateObject var dao = ChallengeDAO()
    
    var body: some View {
        Group {
            switch challengeState {
            case "awaiting":
                ChallengeDetailedPreview(challenge: challenge, state: $challengeState)
                    .onAppear() {
                        switch challenge.category {
                        case "quiz":
                            dao.getQuiz(id: challenge.challengeId)
                        case "lyrics":
                            dao.getLyrics(id: challenge.challengeId)
                        case "twister":
                            dao.getTwister(id: challenge.challengeId)
                        default:
                            return
                        }
                    }
            case "playing":
                switch challenge.category {
                case "quiz":
                    if let quiz = dao.quiz {
                        let game = QuizGame(quiz: quiz)
                        QuizView(game: game, state: $challengeState, resultHandler: $resultHandler, id: challenge.id)
                    }
                case "lyrics":
                    if let lyrics = dao.lyrics {
                        let game = LyricsGame(lyricsChallenge: lyrics)
                        LyricsView(game: game, state: $challengeState, resultHandler: $resultHandler, id: challenge.id)
                    }
                case "twister":
                    if let twister = dao.twister {
                        let game = TwisterGame(twister: twister)
                        TwisterView(game: game, state: $challengeState, resultHandler: $resultHandler, id: challenge.id)
                    }
                case "stringGame":
                    StringGameView(state: $challengeState, resultHandler: $resultHandler, id: challenge.id)
                default:
                    Text("invalid category")
                }
                
                
            default:
                ChallengeCompleted(challengeInfoOpened: $challengeInfoOpened, resultHandler: $resultHandler, revealedChallenge: $revealedChallenge)
            }
        }
        .onChange(of: challengeState) { state in
            if state != "awaiting" {
                notifyParent()
            }
        }
    }
}

//struct ChallengeContainer_Previews: PreviewProvider {
//    static var previews: some View {
//        ChallengeContainer(challenge: Challenge(id: 1, challengeId: 1, name: "quizzz", difficulty: "easy", category: "quiz", description: "Answer these 5 super easy questions you have 10 seconds per question.", coordinates: CLLocationCoordinate2D(latitude: 60.224810974873215, longitude: 24.75657413146672)), notifyParent2: {})
//    }
//}
