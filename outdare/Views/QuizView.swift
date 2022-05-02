//
//  QuizView.swift
//  quiz
//
//  Created by iosdev on 3.4.2022.
//

import SwiftUI

/// UI for the Quiz game. The logic is handled by a QuizGame instance.
///
/// The user is presented several questions and possible answers, and have to answer within a given amount of time. A ChallengeTimer controls the rythm of the game by indicating whether time is over or not. When time is over, the user can click continue and go to the next question.
/// A feature for answering with voice recognition was developed and is fully functional but was not used in the final version of the app.
struct QuizView: View {
    @StateObject var game: QuizGame
    @Binding var state: ChallengeState
    @Binding var resultHandler: ResultHandler
    @State var score: Int = 0
    @StateObject var timer: ChallengeTimer = ChallengeTimer()
    @State var voice = false
    @StateObject private var speechAnalyzer = SpeechAnalyzer()
    @State var input = ""
    let id: Int
    
    var body: some View {
        ZStack {
            VStack {
                ChallengeTimerBar(timer: timer)
                    .onAppear {
                        timer.setTimeLimit(limit: Double(game.timePerQ))
                    }
                ChallengeCount(index: game.index, limit: game.length)
                VStack {
                    if let question = game.question {
                        Text(question)
                            .frame(maxWidth: .infinity, maxHeight: 100)
                            .padding(.horizontal)
                            .background(Color.theme.background)
                            .foregroundColor(Color.white)
                            .cornerRadius(20)
                            .padding(.bottom)
                    }
                    
                    if !voice {
                        if let answers = game.answers, let correctAns = game.correctAns {
                            VStack(spacing: 20) {
                                ForEach(answers, id: \.self) { ans in
                                    Button(action: {
                                        onAnswer(ans: ans)
                                    }) {
                                        Text(ans)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(getTileColor(ans: ans, correctAns: correctAns))
                                            .foregroundColor(Color.white)
                                            .cornerRadius(20)
                                            .shadow(color: Color.theme.icon, radius: (ans == input) ? 0 : 5, x: 0, y: (ans == input) ? 0 : 4)
                                    }
                                }
                            }
                        }
                        
                    } else {
                        VStack {
                            Spacer()
                            TextField("Type here if you cannot talk", text: $input)
                                .textFieldStyle(RoundedTextFieldStyle())
                                .foregroundColor(game.correct == true ? Color.theme.rankingUp : Color.theme.textDark)
                                .onChange(of: speechAnalyzer.recognizedText ?? "") {newValue in
                                    if newValue.count > 0 {
                                        input = newValue
                                    }
                                }
                                .padding()
                            Button(action: {
                                onAnswer(ans: input)
                            }) {
                                Text("Submit")
                                    .padding(.vertical, 10)
                                    .frame(width: 200)
                                    .background(Color.theme.button)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(40)
                                
                            }
                            Spacer()
                            SRButton(speechAnalyzer: speechAnalyzer)
                                .padding()
                        }
                        
                    }
                    
                }
                .padding(.horizontal)
                Spacer()
            }
            .onChange(of: timer.isOver) { isOver in
                if isOver {
                    onAnswer(ans: "")
                }
            }
            .onAppear {
                game.gatherData()
                timer.start()
            }
            .allowsHitTesting(timer.isRunning)
            if let correct = game.correct, let message = game.message {
                ContinueOverlay(message: message, index: game.index, correct: correct, length: game.length, action: {next()})
                    .zIndex(2)
            }
            
        }
        
    }
}

extension QuizView {
    
    /// Sends the user's input to the QuizGame instance which evaluates it. Stops the timer and the speech analyzer (if voice mode is activated)
    func onAnswer(ans: String) {
        input = ans
        timer.stop()
        speechAnalyzer.stop()
        withAnimation {
            game.checkAns(ans: ans)
        }
    }
    
    /// Sends the results to Firestore and shows the ChallengeCompleted view if the game is over, else resets the user input and continues the game.
    func next() {
        game.next()
        if !game.over {
            input = ""
            timer.restart()
        } else {
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
                return
            }
            let challengeId = resultHandler.challengeId
            resultHandler = ResultHandler(userId: uid, challengeId: challengeId, results: game.results, time: Int(timer.totalTime), maxTime: game.length * game.timePerQ)
            resultHandler.pushToDB()
            state = .done
        }
    }
    
    /// Returns the right colors for the quiz answer tiles after the user answers.
    ///
    /// Green if it is the correct answer. Orange if it is the selected answer but it is incorrect and a default color otherwise.
    func getTileColor(ans: String, correctAns: String) -> Color {
        var color = Color.theme.icon
        if game.correct != nil {
            if ans == correctAns {
                color = Color.theme.rankingUp
            }
            if ans == input && ans != correctAns {
                color = Color.theme.rankingDown
            }
        }
        return color
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(game: QuizGame(quiz: Quiz.sample[0]), state: .constant(.playing), resultHandler: .constant(ResultHandler()), id: 0)
    }
}
