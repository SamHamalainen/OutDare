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
    @ObservedObject var timer: ChallengeTimer
    @State var index: Int = 0
    @State var missingPart: String?
    @State var showAns = false
    @ObservedObject private var speechAnalyzer = SpeechAnalyzer()
    @State var input = ""
    @State var correct = false
    @State var resultString = ""
    let timeout = 3.0
    
    init(lyricsChallenge: Lyrics) {
        self.lyricsChallenge = lyricsChallenge
        let timeLimit = Double(lyricsChallenge.data[0].timeLimit)
        timer = ChallengeTimer(timeLimit: timeLimit)
    }
    var body: some View {
        let data = lyricsChallenge.data[index]
        let lyrics = data.lyrics
        let answer = data.missingWords
        VStack {
            ChallengeTimerBar(timer: timer)
                .onChange(of: index) { index in
                    let timeLimit = Double(lyricsChallenge.data[index].timeLimit)
                    timer.setTimeLimit(limit: timeLimit)
                }
            ChallengeCount(index: index, limit: 3)
                .padding(.bottom)
            VStack {
                Text(data.title).font(Font.customFont.normalText)
                Text(data.artist).font(Font.customFont.smallText)
            }
            .padding()
            .background(Color.theme.background)
            .foregroundColor(Color.white)
            .cornerRadius(20)
            .padding(.bottom)
            
            
            if let missingPart = missingPart {
                lyrics.replacingOccurrences(of: "___", with: [Text(missingPart).foregroundColor(showAns ? Color.theme.rankingUp : Color.theme.background).bold()])
                    .font(Font.customFont.normalText.leading(.loose))
                    .lineSpacing(10)
                    .multilineTextAlignment(.leading)
                    .frame(maxHeight: .infinity)
            }
            Spacer()
            Text(resultString)
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
                .padding()
            Button(action: {
                onAnswer(ans: input)
            }) {
                Text("Submit")
                    .padding(.vertical, 10)
                    .frame(width: 200)
                    .font(Font.customFont.btnText)
                    .background(Color.theme.button)
                    .foregroundColor(Color.white)
                    .cornerRadius(40)
                    
            }
            SRButton(speechAnalyzer: speechAnalyzer, text: "Tap to sing")
                .padding()
        }
        .onChange(of: showAns) { showAns in
            if showAns {
                missingPart = answer
            }
        }
        .onChange(of: index) { index in
            missingPart = getHiddenWords(index: index)
        }
        .onAppear {
            missingPart = getHiddenWords(index: index)
            timer.start()
        }
        .allowsHitTesting(timer.isRunning)
    }
}

extension LyricsView {
    func onAnswer(ans: String) {
        showAns = true
        let result: LyricsResult = lyricsChallenge.data[index].checkAns(ans: ans)
        resultString = "\(result.matchStatus) \(result.comment.isEmpty ? "" : result.comment) \(result.score)/\(result.total)"
        speechAnalyzer.stop()
        timer.stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
            if index + 1 < lyricsChallenge.data.count {
                resultString = ""
                input = ""
                correct = false
                showAns = false
                index += 1
                timer.restart()
            }
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

struct LyricsView_Previews: PreviewProvider {
    static var previews: some View {
        LyricsView(lyricsChallenge: Lyrics.sample[0])
    }
}
