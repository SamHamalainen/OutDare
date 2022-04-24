//
//  TwisterView.swift
//  outdare
//
//  Created by iosdev on 21.4.2022.
//

import SwiftUI
import WrappingStack

struct TwisterView: View {
    let twister: Twister
    let setState: (String) -> Void
    let setResult: ((Double, Double)) -> Void
    @StateObject var timer: ChallengeTimer = ChallengeTimer()
    @State var index: Int = 0
    @State var score: Double = 0.0
    @StateObject private var speechAnalyzer = SpeechAnalyzer()
    @State var input = ""
    @State var resultString = ""
    @State var correct = false
    @StateObject var handler: TwisterHandler = TwisterHandler()
    @State var recognizedLength = 0
        
    init(twister: Twister, setState: @escaping (String) -> Void, setResult: @escaping ((Double, Double)) -> Void) {
        self.twister = twister
        self.setState = setState
        self.setResult = setResult
        print("init")
    }
    
    var body: some View {
        let data = twister.data[index]
        ZStack {
//            if handler.matchingIndices.count == data.textArray.count {
//                ContinueOverlay(message: $resultString, index: $index, correct: $correct, lastIndex: twister.data.count - 1) {
//                    next()
//                }
//            }
            VStack {
                ChallengeTimerBar(timer: timer)
                    .onChange(of: index) { index in
                        timer.setTimeLimit(limit: Double(data.timeLimit))
                    }
                    .onChange(of: timer.isOver) { isOver in
                        if isOver {
                            onAnswer(ans: "")
                        }
                    }
                    .onAppear {
                        timer.setTimeLimit(limit: Double(data.timeLimit))
                    }
                
                ChallengeCount(index: index, limit: 3)
                Text(speechAnalyzer.recognizedText?.components(separatedBy: " ").last ?? " ")
                    .padding()
                WrappingHStack(id: \.self, alignment: .leading, horizontalSpacing: 5, verticalSpacing: 10) {
                    ForEach(data.textArray.indices, id: \.self) {i in
                        VStack {
                            Text(data.textArray[i])
                                .font(Font.customFont.normalText)
                                .foregroundColor(handler.matchingIndices.contains(i) ? Color.theme.rankingUp : Color.theme.textDark)
                                .frame(minWidth: CGFloat(data.textArray[i].count * 12), alignment: .leading)
                                .padding(.bottom, i == handler.matchingIndices.last ? 5 : 0)
                        }
                        .frame(height: 15)
                    }
                }
                .onChange(of: speechAnalyzer.recognizedText) { newText in
                    if let last = newText?.components(separatedBy: " ").last {
                        if handler.matchingIndices.count < data.textArray.count {
                            handler.checkWord(word: last)
                        }                        
                    }
                }
                .onAppear {
                    handler.newData(newData: data)
                }
                .frame(maxHeight: .infinity)
                .padding()
                
                SRButton(speechAnalyzer: speechAnalyzer, size: 40, padding: 40, text: "Tap to speak")
                    .padding(.bottom)
            }
            .onChange(of: handler.matchingIndices) {indices in
                if handler.matchingIndices.count == data.textArray.count {
                    onAnswer(ans: "")
                }
            }
            .allowsHitTesting(timer.isRunning)
        }
        .onAppear {
            timer.start()
        }
    }
}

extension TwisterView {
    func onAnswer(ans: String) {
        speechAnalyzer.stop()
        timer.stop()
    }
    
    func next() {
            if index < twister.data.count - 1 {
                input = ""
                index += 1
                handler.newData(newData: twister.data[index])
                timer.restart()
            } else {
                print("final score \(score)")
                print("total time \(timer.totalTime)")
                setResult((score, timer.totalTime))
                setState("done")
            }
    }
}

struct TwisterView_Previews: PreviewProvider {
    static var previews: some View {
        TwisterView(twister: Twister.sample[0], setState: {_ in}, setResult: {_ in})
    }
}
