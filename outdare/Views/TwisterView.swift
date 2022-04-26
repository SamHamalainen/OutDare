//
//  TwisterView.swift
//  outdare
//
//  Created by iosdev on 21.4.2022.
//

import SwiftUI
import WrappingStack

struct TwisterView: View {
    let game: TwisterGame
    @Binding var state: String
    @Binding var resultHandler: ResultHandler
    @StateObject var timer: ChallengeTimer = ChallengeTimer()
    @StateObject private var speechAnalyzer = SpeechAnalyzer()
    @State var input = ""
    let id: Int
    
    var body: some View {
        ZStack {
            if game.matchingIndices.count == game.textArray.count || timer.isOver {
                ContinueOverlay(message: game.message, index: game.index, correct: game.correct, length: game.length, action: {next()})
            }
            VStack {
                ChallengeTimerBar(timer: timer)
                    .onChange(of: game.index) { index in
                        timer.setTimeLimit(limit: Double(game.timeLimit))
                    }
                    .onChange(of: timer.isOver) { isOver in
                        if isOver {
                            onOver()
                        }
                    }
                    .onAppear {
                        timer.setTimeLimit(limit: Double(game.timeLimit))
                    }
                
                ChallengeCount(index: game.index, limit: game.length)
                
                WrappingHStack(id: \.self, alignment: .leading, horizontalSpacing: 5, verticalSpacing: 10) {
                    ForEach(game.textArray.indices, id: \.self) {i in
                        VStack {
                            Text(game.textArray[i])
                                .font(Font.customFont.normalText)
                                .foregroundColor(game.matchingIndices.contains(i) ? Color.theme.rankingUp : Color.theme.textDark)
                                .frame(minWidth: CGFloat(game.textArray[i].count * 12), alignment: .leading)
                            if let last = game.matchingIndices.last {
                                if i == last + 1 {
                                    Image(systemName: "arrowtriangle.up.fill")
                                        .font(.system(size: 5))
                                }
                            }
                        }
                        .frame(height: 20)
                    }
                }
                .onChange(of: speechAnalyzer.recognizedText) { newText in
                    if let last = newText?.components(separatedBy: " ").last {
                        if game.matchingIndices.count < game.textArray.count {
                            game.checkWord(word: last)
                        }                        
                    }
                }
                .frame(maxHeight: .infinity)
                .padding()
                
                SRButton(speechAnalyzer: speechAnalyzer, size: 40, padding: 40, text: "Tap to speak")
                    .padding(.bottom)
            }
            .onChange(of: game.matchingIndices) {indices in
                if game.matchingIndices.count == game.textArray.count {
                    onOver()
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
    func onOver() {
        speechAnalyzer.stop()
        timer.stop()
        game.makeResult()
    }
    
    func next() {
        game.next()
        if !game.over {
            input = ""
            timer.restart()
        } else {
            print(game.results)
            resultHandler = ResultHandler(userId: 1, challengeId: id, results: game.results, time: Int(timer.totalTime), maxTime: game.data.map {$0.timeLimit}.reduce(0, +))
            resultHandler.pushToDB()
            state = "done"
        }
    }
}

//struct TwisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        TwisterView(twister: Twister.sample[0], setState: {_ in}, setResult: {_ in})
//    }
//}
