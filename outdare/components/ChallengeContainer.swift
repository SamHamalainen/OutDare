//
//  ChallengeContainer.swift
//  quiz
//
//  Created by iosdev on 4.4.2022.
//

import SwiftUI
import CoreLocation
import Speech

/// View that contains a challenge preview view, the challenge view and the challenge result view
///
/// Fetches the relevant data for a given challenge according to its category, then displays the right view according to the advancement state of the challenge.
struct ChallengeContainer: View {
    @Binding var challengeInfoOpened: Bool
    @Binding var revealedChallenge: Bool
    let challenge: Challenge
    let notifyParent: () -> Void
    @State var challengeState = ChallengeState.awaiting
    @State var resultHandler: ResultHandler = ResultHandler()
    @StateObject var dao = ChallengeDAO()
    
    var body: some View {
        Group {
            // Displays the right view (according to ChallengeState) for the right challenge (according to ChallengeCategory)
            switch challengeState {
                
                // Showing challenge preview
            case .awaiting:
                ChallengeDetailedPreview(challenge: challenge, state: $challengeState)
                    .onAppear() {
                        resultHandler = ResultHandler(challengeId: challenge.id)
                        switch challenge.category {
                        case .quiz:
                            dao.getQuiz(id: challenge.challengeId)
                        case .lyrics:
                            dao.getLyrics(id: challenge.challengeId)
                        case .twister:
                            dao.getTwister(id: challenge.challengeId)
                        default:
                            return
                        }
                    }
                
                // Showing the challenge view where the user plays the game
            case .playing:
                switch challenge.category {
                case .quiz:
                    if let quiz = dao.quiz {
                        let game = QuizGame(quiz: quiz)
                        QuizView(game: game, state: $challengeState, resultHandler: $resultHandler, id: challenge.id)
                    }
                case .lyrics:
                    if let lyrics = dao.lyrics {
                        let game = LyricsGame(lyricsChallenge: lyrics)
                        LyricsView(game: game, state: $challengeState, resultHandler: $resultHandler, id: challenge.id)
                    }
                case .twister:
                    if let twister = dao.twister {
                        let game = TwisterGame(twister: twister)
                        TwisterView(game: game, state: $challengeState, resultHandler: $resultHandler, id: challenge.id)
                    }
                case .string:
                    StringGameView(state: $challengeState, resultHandler: $resultHandler, id: challenge.id)
                }
                
                // Showing the results of the challenge
            case .done:
                ChallengeCompleted(challengeInfoOpened: $challengeInfoOpened, resultHandler: $resultHandler, revealedChallenge: $revealedChallenge)
            }
        }
        .onChange(of: challengeState) { state in
            if state != ChallengeState.awaiting {
                notifyParent()
            }
        }
    }
}

/// Describes the state of the current challenge
///
/// Awaiting means the preview is shown, playing means the user is playing and done means that the user is shown the results
enum ChallengeState {
    case awaiting, playing, done
}

struct ChallengeContainer_Previews: PreviewProvider {
    static var previews: some View {        
        ChallengeContainer(challengeInfoOpened: .constant(true), revealedChallenge: .constant(true), challenge: Challenge.sample[0], notifyParent: {})
    }
}
