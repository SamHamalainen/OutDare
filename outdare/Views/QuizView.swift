//
//  QuizView.swift
//  quiz
//
//  Created by iosdev on 3.4.2022.
//

import SwiftUI

struct QuizView: View {
    @StateObject var game: QuizGame
    @Binding var state: String
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
    func onAnswer(ans: String) {
        input = ans
        timer.stop()
        speechAnalyzer.stop()
        withAnimation {
            game.checkAns(ans: ans)
        }
    }
    
    func next() {
        game.next()
        if !game.over {
            input = ""
            timer.restart()
        } else {
            print(game.results)
            resultHandler = ResultHandler(userId: 1, challengeId: id, results: game.results, time: Int(timer.totalTime), maxTime: game.length * game.timePerQ)
            resultHandler.pushToDB()
            state = "done"
        }
    }
    
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

//struct QuizView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuizView(quiz: Quiz.sample[0], setState: {_ in}, setResult: {_ in})
//    }
//}
