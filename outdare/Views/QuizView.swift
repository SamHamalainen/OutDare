//
//  QuizView.swift
//  quiz
//
//  Created by iosdev on 3.4.2022.
//

import SwiftUI

struct QuizView: View {
    let quiz: Quiz
    let setState: (String) -> Void
    let setResult: ((Double, Double)) -> Void
    @State var index: Int = 0
    @State var score: Int = 0
    let timeout = 2.0
    @StateObject var timer: ChallengeTimer = ChallengeTimer()
    @State var voice = false
    @ObservedObject private var speechAnalyzer = SpeechAnalyzer()
    @State var input = ""
    @State var correct = false
    @State var submitted = false
    @State var message = ""
    
    init(quiz: Quiz, setState: @escaping (String) -> Void, setResult: @escaping ((Double, Double)) -> Void) {
        self.quiz = quiz
        self.setState = setState
        self.setResult = setResult
    }
    
    var body: some View {
        ZStack {
            if submitted {
                ContinueOverlay(message: $message, index: $index, correct: $correct, lastIndex: quiz.data.count - 1, action: {next()})
            }
            VStack {
                ChallengeTimerBar(timer: timer)
                    .onAppear {
                        timer.setTimeLimit(limit: quiz.timePerQuestion)
                    }
                ChallengeCount(index: index, limit: quiz.data.count)
                VStack {
                    Text(quiz.data[index].question)
                        .frame(maxWidth: .infinity, maxHeight: 100)
                        .background(Color.theme.background)
                        .foregroundColor(Color.white)
                        .cornerRadius(20)
                        .padding(.bottom)
                        
                    if !voice {
                        VStack(spacing: 20) {
                            ForEach(quiz.data[index].answers, id: \.self) { ans in
                                Button(action: {onAnswer(ans: ans)}) {
                                    Text(ans)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background((!input.isEmpty && ans == quiz.data[index].correctAns) ? Color.theme.rankingUp : (input == ans && ans != quiz.data[index].correctAns) ? Color.theme.rankingDown : Color.theme.icon)
                                        .foregroundColor(Color.white)
                                        .cornerRadius(20)
                                        .shadow(color: Color.theme.icon, radius: (ans == input) ? 0 : 5, x: 0, y: (ans == input) ? 0 : 4)
                                }
                            }
                        }
                    } else {
                        VStack {
                            Spacer()
                            TextField("Type here if you cannot talk", text: $input)
                                .textFieldStyle(RoundedTextFieldStyle())
                                .foregroundColor(correct ? Color.theme.rankingUp : Color.theme.textDark)
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
            }
            .onChange(of: timer.isOver) { isOver in
                if isOver {
                    onAnswer(ans: "")
                }
            }
            .onAppear {
                timer.start()
            }
            .allowsHitTesting(timer.isRunning)
        }
    }
}

extension QuizView {
    func onAnswer(ans: String) {
        input = ans
        checkAnswer()
        timer.stop()
        speechAnalyzer.stop()
        withAnimation {
            submitted = true
        }
    }
        
    func next() {
        submitted = false
        if index + 1 < quiz.data.count {
            resetAnswer()
            index += 1
            timer.restart()
        } else {
            print("final score \(score)")
            print("total time \(timer.totalTime)")
            setResult((Double(score), timer.totalTime))
            setState("done")
        }
    }
    
    func resetAnswer() {
        input = ""
        correct = false
    }
    
    func checkAnswer() {
        let correctAns = quiz.data[index].correctAns
        print(input)
        let isCorrect = !voice ? (input == correctAns) : (input.lowercased().trimmingCharacters(in: .whitespaces) == correctAns.lowercased())
        correct = isCorrect
        if isCorrect {
            score += 1
            message = "Correct answer 🔥"
        } else {
            message = "Answer: \(correctAns)"
                      
        }
        print(score)
    }
}

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(quiz: Quiz.sample[0], setState: {_ in}, setResult: {_ in})
    }
}
