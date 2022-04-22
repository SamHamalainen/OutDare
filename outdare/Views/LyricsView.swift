//
//  LyricsView.swift
//  outdare
//
//  Created by iosdev on 12.4.2022.
//

import SwiftUI

extension String {
    func replacingOccurrences(of: String, with: [Text]) -> Text {
        return self.components(separatedBy: of).enumerated().map({(i, s) in
            return i < with.count ? Text(s) + with[i] : Text(s)
        }).reduce(Text(""), { (r, t) in
            return r + t
        })
    }
}

struct LyricsView: View {
    let lyricsChallenge: Lyrics
    let setState: (String) -> Void
    let setResult: ((Double, Double)) -> Void
    @StateObject var timer: ChallengeTimer = ChallengeTimer()
    @State var index: Int = 0
    @State var score: Double = 0.0
    @State var missingPart: String?
    @State var showAns = false
    @ObservedObject private var speechAnalyzer = SpeechAnalyzer()
    @State var input = ""
    @State var correct = false
    @State var resultString = ""
    
    let timeout = 3.0
    
    init(lyricsChallenge: Lyrics, setState: @escaping (String) -> Void, setResult: @escaping ((Double, Double)) -> Void) {
        self.lyricsChallenge = lyricsChallenge
        self.setState = setState
        self.setResult = setResult
    }
    
    var body: some View {
        let data = lyricsChallenge.data[index]
        let lyrics = data.lyrics
        let answer = data.missingWords
        ZStack {
            if !resultString.isEmpty {
                ContinueOverlay(message: $resultString, index: $index, correct: $correct, lastIndex: lyricsChallenge.data.count - 1) {
                    next()
                }
            }
            VStack {
                ChallengeTimerBar(timer: timer)
                    .onAppear {
                        timer.setTimeLimit(limit: Double(data.timeLimit))
                    }
                    .onChange(of: index) { index in
                        timer.setTimeLimit(limit: Double(data.timeLimit))
                    }
                ChallengeCount(index: index, limit: 3)
                VStack {
                    Text("\(data.title) - \(data.artist)").font(Font.customFont.normalText)
                    if let missingPart = missingPart {
                        lyrics.replacingOccurrences(of: "___", with: [Text(missingPart).foregroundColor(showAns ? Color.theme.rankingUp : Color.theme.background).bold()])
                            .font(Font.customFont.normalText.leading(.loose))
                            .lineSpacing(10)
                            .multilineTextAlignment(.leading)
                            .frame(maxHeight: .infinity)
                    }
                }
                .padding()
                HStack {
                    TextField("Sing or type here", text: $input)
                        .textFieldStyle(RoundedTextFieldStyle())
                        .foregroundColor(correct ? Color.theme.rankingUp : Color.theme.textDark)
                        .font(Font.customFont.normalText)
                        .autocapitalization(.none)
                        .onChange(of: speechAnalyzer.recognizedText ?? "") {newValue in
                            if newValue.count > 0 && !correct {
                                input = newValue
                            }
                        }
                        .onChange(of: input) { newValue in
                            correct = (newValue.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "’", with: "'") == answer.lowercased())
                            if correct {
                                onAnswer(ans: input)
                            }
                        }
                    Button(action: {
                        onAnswer(ans: input)
                    }) {
                        Image(systemName: "arrow.right.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color.theme.background)
                    }
                }
                .padding()
                SRButton(speechAnalyzer: speechAnalyzer, size: 40, padding: 40, text: "Tap to sing")
                    .padding(.bottom)
            }
            .onChange(of: showAns) { showAns in
                if showAns {
                    missingPart = answer
                }
            }
            .onChange(of: index) { index in
                missingPart = getHiddenWords(index: index)
            }
            .onChange(of: timer.isOver){ isOver in
                if isOver {
                    onAnswer(ans: input)
                }
            }
            .onAppear {
                missingPart = getHiddenWords(index: index)
                timer.start()
            }
        .allowsHitTesting(timer.isRunning)
        }
    }
}

extension LyricsView {
    func onAnswer(ans: String) {
        showAns = true
        let result: LyricsResult = lyricsChallenge.data[index].checkAns(ans: ans)
        score += result.score
        speechAnalyzer.stop()
        timer.stop()
        withAnimation {
            resultString = "\(result.matchStatus)"

        }
    }
    
    func next() {
            if index < lyricsChallenge.data.count - 1 {
                resultString = ""
                input = ""
                correct = false
                showAns = false
                index += 1
                timer.restart()
            } else {
                print("final score \(score)")
                print("total time \(timer.totalTime)")
                setResult((score, timer.totalTime))
                setState("done")
            }
    }
    
    func getHiddenWords(index: Int) -> String {
        var string = ""
        let answerArray = lyricsChallenge.data[index].missingWordsArray
        for (index, word) in answerArray.enumerated() {
            let isLast = (index == answerArray.count - 1)
            string += (String(repeating: "_", count: word.count))
            string += (isLast) ? "" : " "
        }
        return string
    }
}

//struct LyricsView_Previews: PreviewProvider {
//    static var previews: some View {
//        LyricsView(lyricsChallenge: Lyrics.sample[0])
//    }
//}
