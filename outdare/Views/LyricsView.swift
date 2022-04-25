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
    let game: LyricsGame
    @Binding var state: String
    @Binding var resultHandler: ResultHandler
    @StateObject var timer: ChallengeTimer = ChallengeTimer()
    @State var showAns = false
    @StateObject private var speechAnalyzer = SpeechAnalyzer()
    @State var input = ""
    let id: Int
    
    var body: some View {
        ZStack {
            if showAns {
                if let correct = game.correct {
                    ContinueOverlay(message: game.resultString, index: game.index, correct: correct, length: game.length, action: {next()})
                }
            }
            VStack {
                if let timeLimit = game.timeLimit {
                    ChallengeTimerBar(timer: timer)
                        .onChange(of: game.index) { index in
                            timer.setTimeLimit(limit: Double(timeLimit))
                        }
                        .onAppear {
                            timer.setTimeLimit(limit: Double(timeLimit))
                        }
                }
                ChallengeCount(index: game.index, limit: game.length)
                VStack {
                    if let artist = game.artist, let title = game.title {
                        Text("\(title) - \(artist)").font(Font.customFont.normalText)
                    }
                    if let missingPart = game.missingPart {
                        game.lyrics.replacingOccurrences(of: "___", with: [Text(missingPart).foregroundColor(showAns ? Color.theme.rankingUp : Color.theme.background).bold()])
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
                        .foregroundColor(game.correct == true ? Color.theme.rankingUp : Color.theme.textDark)
                        .font(Font.customFont.normalText)
                        .autocapitalization(.none)
                        .onChange(of: speechAnalyzer.recognizedText ?? "") {newValue in
                            if newValue.count > 0 && game.correct != true {
                                input = newValue
                            }
                        }
                        .onChange(of: input) { newValue in
                            let isCorrect = (newValue.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "’", with: "'") == game.missingWords.lowercased())
                            if isCorrect {
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
            .onChange(of: timer.isOver){ isOver in
                if isOver {
                    onAnswer(ans: input)
                }
            }
            .onAppear {
                timer.start()
            }
        .allowsHitTesting(timer.isRunning)
        }
    }
}

extension LyricsView {
    func onAnswer(ans: String) {
        showAns = true
        speechAnalyzer.stop()
        timer.stop()
        withAnimation {
            game.checkAns(ans: input)
        }
    }
    
    func next() {
        game.next()
        if !game.over {
            input = ""
            showAns = false
            timer.restart()
        } else {
            print(game.results)
            resultHandler = ResultHandler(userId: 1, challengeId: id, results: game.results, time: Int(timer.totalTime), maxTime: game.data.map {$0.timeLimit}.reduce(0, +))
            state = "done"
        }
    }
    
    
}

//struct LyricsView_Previews: PreviewProvider {
//    static var previews: some View {
//        LyricsView(lyricsChallenge: Lyrics.sample[0])
//    }
//}
