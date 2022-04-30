//
//  TwisterView.swift
//  outdare
//
//  Created by iosdev on 21.4.2022.
//

import SwiftUI

struct TwisterView: View {
    let game: TwisterGame
    @Binding var state: ChallengeState
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
                WrappedText(words: game.textArray, matchingIndices: game.matchingIndices)
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
            let challengeId = resultHandler.challengeId
            resultHandler = ResultHandler(challengeId: challengeId, results: game.results, time: Int(timer.totalTime), maxTime: game.data.map {$0.timeLimit}.reduce(0, +))
            resultHandler.pushToDB()
            state = .done
        }
    }
}

//struct TwisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        TwisterView(twister: Twister.sample[0], setState: {_ in}, setResult: {_ in})
//    }
//}


struct WordEnumerated: Identifiable, Hashable {
    let id: UUID = UUID()
    let index: Int
    let word: String
    
    init(_ index: Int, _ word: String) {
        self.index = index
        self.word = word
    }
}

struct WrappedText: View {
    let words: [String]
    var grouped: [[WordEnumerated]] {
        return createGrouped(words)
    }
    let screenWidth = UIScreen.main.bounds.width
    let matchingIndices: [Int]
    
    private func createGrouped(_ words: [String]) -> [[WordEnumerated]] {
        var grouped: [[WordEnumerated]] = [[WordEnumerated]]()
        var tempItems: [WordEnumerated] =  [WordEnumerated]()
        var width: CGFloat = 0
        
        for (index, word) in words.enumerated() {
            let label = UILabel()
            label.text = word
            label.sizeToFit()
            
            let labelWidth = label.frame.size.width + 32
            
            if (width + labelWidth + 55) < screenWidth {
                width += labelWidth
                tempItems.append(WordEnumerated(index, word))
            } else {
                width = labelWidth
                grouped.append(tempItems)
                tempItems.removeAll()
                tempItems.append(WordEnumerated(index, word))
            }
        }
        grouped.append(tempItems)
        return grouped
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(grouped, id: \.self) { subItems in
                HStack(spacing: 10) {
                    ForEach(subItems) { wordEnum in
                        VStack {
                            Text(wordEnum.word)
                                .fixedSize()
                                .font(Font.customFont.normalText)
                                .foregroundColor(matchingIndices.contains(wordEnum.index) ? Color.theme.rankingUp : Color.theme.textDark)
                            if let last = matchingIndices.last {
                                if wordEnum.index == last + 1 {
                                    Image(systemName: "arrowtriangle.up.fill")
                                        .font(.system(size: 5))
                                }
                            }
                        }
                        .frame(height: 20)
                    }
                }
            }
        }
    }
}
