//
//  StringGameView.swift
//  outdare
//
//  Created by iosdev on 22.4.2022.
//

import SwiftUI

struct StringGameView: View {
    @StateObject var game = StringGame()
    @Binding var state: String
    @Binding var resultHandler: ResultHandler
    @State var input = ""
    @StateObject var timer = ChallengeTimer()
    @State var status = ""
    @StateObject var speechAnalyzer = SpeechAnalyzer()
    let id: Int
    
    var body: some View {
        let positive = ["Outstanding", "Excellent", "Good"].contains(status)
        ZStack {
            if timer.isOver {
                ContinueOverlay(message: "Done", index: 1, correct: true, length: 2, action: {next()})
            }
            VStack {
                ChallengeTimerBar(timer: timer)
                    .onAppear {
                        timer.setTimeLimit(limit: 60.0)
                        timer.start()
                    }
                HStack(alignment: .top) {
                    VStack {
                        Text("Score")
                            .font(Font.customFont.normalText)
                        Text("\(Int(game.score))")
                            .font(Font.customFont.largeText)
                            .foregroundColor(Color.theme.background)
                    }
                    Spacer()
                    VStack {
                        Text("Skips left: \(game.skips)")
                            .font(Font.customFont.normalText)
                        Button(action: {
                            game.skip()
                        }) {
                            Text("Skip")
                                .padding(.vertical, 7)
                                .padding(.horizontal, 13)
                                .font(Font.customFont.btnText)
                                .background(Color.theme.background)
                                .foregroundColor(Color.white)
                                .cornerRadius(40)
                        }
                        .disabled(game.skips == 0)
                    }
                }
                .padding(.horizontal)
                
                Text(game.random)
                    .padding(50)
                    .background(Color.theme.background)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .font(Font.customFont.extraLargeText)
                    .cornerRadius(.infinity)
                    .frame(maxHeight: .infinity)
                
                VStack {
                    if !status.isEmpty {
                        Text(status)
                            .onChange(of: input) { _ in
                                status = ""
                            }
                            .padding()
                            .font(Font.customFont.normalText)
                            .foregroundColor(positive ? Color.theme.rankingUp : Color.theme.rankingDown)
                            .onAppear {
                                if positive {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                        withAnimation {
                                            status = ""
                                        }
                                    }
                                }
                            }
                            .transition(.opacity)
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: 40)
                
                TextField("Speak or type", text: $input)
                    .textFieldStyle(RoundedTextFieldStyle())
                    .textCase(.lowercase)
                    .onChange(of: speechAnalyzer.recognizedText) { newText in
                        if let last = newText?.components(separatedBy: " ").last {
                            input = last
                        }
                    }
                    .disableAutocorrection(true)
                    .onSubmit {
                        onSubmit()
                    }
                    
                Button(action: {
                    onSubmit()
                }) {
                    Text("Submit")
                        .padding(.vertical, 10)
                        .frame(width: 200)
                        .font(Font.customFont.btnText)
                        .background(Color.theme.button)
                        .foregroundColor(Color.white)
                        .cornerRadius(40)
                }
                .padding()
                           
                SRButton(speechAnalyzer: speechAnalyzer, size: 30, padding: 30)
            }
            .padding()
            .allowsHitTesting(timer.isRunning)
        }
        
    }
}

extension StringGameView {
    func next() {
        print(game.results)
        resultHandler = ResultHandler(userId: 1, challengeId: id, results: game.results)
        resultHandler.pushToDB()
        state = "done"
    }
    
    func onSubmit() {
        if input.components(separatedBy: " ").count > 1 {
            status = "Only one word allowed"
        } else {
            let result = game.checkWord(word: input)
            status = result
            if ["Outstanding", "Excellent", "Good"].contains(result) {
                speechAnalyzer.stop()
                input = ""
            }
        }
    }
}

//struct StringGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        StringGameView()
//    }
//}
