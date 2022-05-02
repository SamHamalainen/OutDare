//
//  LyricsView.swift
//  outdare
//
//  Created by iosdev on 12.4.2022.
//

import SwiftUI

/// UI for Lyrics game. The logic is handled by a LyricsGame instance.
///
/// The user is shown incomplete lyrics of a song and has to provide the missing part either by speaking or typing.
struct LyricsView: View {
    let game: LyricsGame
    @Binding var state: ChallengeState
    @Binding var resultHandler: ResultHandler
    @StateObject var timer: ChallengeTimer = ChallengeTimer()
    @State var showAns = false
    @StateObject private var speechAnalyzer = SpeechAnalyzer()
    @State var input = ""
    let id: Int
    
    var body: some View {
        ZStack {
            // Pop up that gives a feedback to the user on their previous answer and allows them to continue the game
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
                    // TextView which first shows the incomplete lyrics with the missing part being hidden then shows the complete lyrics upon answer.
                    if let missingPart = game.missingPart {
                        game.lyrics.replacingOccurrences(of: "___", with: [Text(missingPart).foregroundColor(showAns ? Color.theme.rankingUp : Color.theme.background).bold()])
                            .font(Font.customFont.normalText.leading(.loose))
                            .lineSpacing(10)
                            .multilineTextAlignment(.leading)
                            .frame(maxHeight: .infinity)
                    }
                }
                .padding()
                // Text Field that shows the user input (vocal or typed)
                HStack {
                    TextField(LocalizedStringKey("Sing or type here"), text: $input)
                        .textFieldStyle(RoundedTextFieldStyle())
                        .foregroundColor(game.correct == true ? Color.theme.rankingUp : Color.theme.textDark)
                        .font(Font.customFont.normalText)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
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
    /// Sends the user's answer to the LyricsGame instance which evaluates the answer. Speech Analyzer and timer are stopped
    func onAnswer(ans: String) {
        showAns = true
        speechAnalyzer.stop()
        timer.stop()
        withAnimation {
            game.checkAns(ans: input)
        }
    }
    
    /// Ends the game by showing results and sending it to firestore if the last lyrics where completed. Otherwise, restarts the timer and continues the game.
    func next() {
        game.next()
        if !game.over {
            input = ""
            showAns = false
            timer.restart()
        } else {
            print(game.results)
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
                return
            }
            let challengeId = resultHandler.challengeId
            resultHandler = ResultHandler(userId: uid, challengeId: challengeId, results: game.results, time: Int(timer.totalTime), maxTime: game.data.map {$0.timeLimit}.reduce(0, +))
            resultHandler.pushToDB()
            state = .done
        }
    }
}

extension String {
    /// Returns a Text view which displays a string in which the occurrences OF a given string have been replaced WITH provided Text views. Useful to replace words in lyrics with hidden strings.
    func replacingOccurrences(of: String, with: [Text]) -> Text {
        return self.components(separatedBy: of).enumerated().map({(i, s) in
            return i < with.count ? Text(s) + with[i] : Text(s)
        }).reduce(Text(""), { (r, t) in
            return r + t
        })
    }
}


struct LyricsView_Previews: PreviewProvider {
    static var previews: some View {
        LyricsView(game: LyricsGame(lyricsChallenge: Lyrics.sample[0]), state: .constant(.playing), resultHandler: .constant(ResultHandler()), id: 1)
    }
}
