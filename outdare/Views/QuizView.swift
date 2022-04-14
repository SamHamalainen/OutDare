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
    let setResult: ((Int, Double)) -> Void
    @State var index: Int = 0
    @State var score: Int = 0
    let timeout = 2.0
    let label: String = ""
    @State var timeCount = 0.0
    @State var timer: Timer? = nil
    @State var selectedAns: String? = nil
    @State var totalTime: Double = 0.0
    
    var body: some View {
        VStack {
            ProgressView(label, value: timeCount, total: quiz.timePerQuestion)
                .padding()
                .tint(Color.theme.icon)
            ChallengeCount(index: index, limit: quiz.data.count)
            VStack {
                Text(quiz.data[index].question)
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .background(Color.theme.background)
                    .foregroundColor(Color.white)
                    .cornerRadius(20)
                    .padding(.bottom)
                    
                VStack(spacing: 20) {
                    ForEach(quiz.data[index].answers, id: \.self) { ans in
                        Button(action: {onAnswer(ans: ans)}) {
                            Text(ans)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background((selectedAns != nil && ans == quiz.data[index].correctAns && selectedAns != "") ? Color.theme.rankingUp : (selectedAns == ans && ans != quiz.data[index].correctAns) ? Color.theme.rankingDown : Color.theme.icon)
                                .foregroundColor(Color.white)
                                .cornerRadius(20)
                                .shadow(color: Color.theme.icon, radius: (ans == selectedAns) ? 0 : 5, x: 0, y: (ans == selectedAns) ? 0 : 4)
                                
                        }
                        .disabled(selectedAns != nil)
                    }
                }
            }
            .padding(.horizontal)
        }
        .onAppear {
            start()
        }
    }
    
    func onAnswer(ans: String) {
        selectedAns = ans
        totalTime += timeCount
        stop()
        if ans == quiz.data[index].correctAns {
            score += 1
            print(score)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            if index + 1 < quiz.data.count {
                index += 1
                selectedAns = nil
                restart()
            } else {
                print("final score \(score)")
                print("total time \(totalTime)")
                setResult((score, totalTime))
                setState("done")
            }
        }
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {timer in
            if timeCount < quiz.timePerQuestion - 0.01 {
                timeCount += 0.01
            } else {
                onAnswer(ans: "")
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

struct QuizView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(quiz: Quiz.sample[0], setState: {_ in}, setResult: {_ in})
    }
}
