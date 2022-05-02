//
//  TwisterView.swift
//  outdare
//
//  Created by iosdev on 21.4.2022.
//

import SwiftUI

/// UI for the Tongue Twister game. The logic is handled by a TwisterGame instance.
///
/// The user is presented a Tongue Twister, which they have to pronounce as fast and accurately as possible. Speech Recognition is used to record the words pronounced by the user. The last pronounced word is compared to the next word to be pronounced. If they match, the next word can be pronounced and so on. This was the most difficult game to create since Speech Recognition is not perfect as it is not always accurate and is a bit slower than normal speech speed.
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
            // Shows a feedback to the users performance on the previous tongue twister and prompts them to continue
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
                
                // Displays the tongue twister and updates the color of words to green as they get pronounced
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
    /// When a tongue twister has been pronounced or time is over, stops the timer and speech recognition, and creates a ResultItem
    func onOver() {
        speechAnalyzer.stop()
        timer.stop()
        game.makeResult()
    }
    
    // Shows the results and push them to firestore if the game is over. Sets up the next tongue twister otherwise
    func next() {
        game.next()
        if !game.over {
            input = ""
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

struct TwisterView_Previews: PreviewProvider {
    static var previews: some View {
        TwisterView(game: TwisterGame(twister: Twister.sample[0]), state: .constant(.playing), resultHandler: .constant(ResultHandler()), id: 1)
    }
}

/// Pairs a string with its index in an array to facilitate the WrappedText view
struct WordEnumerated: Identifiable, Hashable {
    let id: UUID = UUID()
    let index: Int
    let word: String
    
    init(_ index: Int, _ word: String) {
        self.index = index
        self.word = word
    }
}

/// View which displays the words of a text as in a Hstack of individual Text views which wraps to new lines.
struct WrappedText: View {
    let words: [String]
    var grouped: [[WordEnumerated]] {
        return createGrouped(words)
    }
    let screenWidth = UIScreen.main.bounds.width
    let matchingIndices: [Int]
    
    /// Creates an array of arrays of WordEnumerated objects. Each inner array represents is a new row of the wrapped text view. It is calculated by measuring the width taken up by a word and comparing it to the total width of a screen. When words take up more space then the screen size, a new inner array is created and so on.
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
