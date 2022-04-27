//
//  ChallengeCompleted.swift
//  quiz
//
//  Created by iosdev on 4.4.2022.
//

import SwiftUI

struct ChallengeCompleted: View {
    @Binding var challengeInfoOpened: Bool
    @Binding var resultHandler: ResultHandler
    @Binding var revealedChallenge: Bool
    @State var showScore = false
   
    var body: some View {
        GeometryReader { metrics in
            VStack {
                HStack {
                    Text("Challenge completed 🎉")
                        .padding()
                        .font(Font.customFont.largeText)
                        .transition(.fade)
                }
                .frame(maxWidth: .infinity)
                
                if showScore {
                    VStack {
                        Text("Score")
                            .padding()
                            .foregroundColor(Color.theme.background)
                            .font(Font.customFont.largeText)
                        ScrollView {
                            VStack(spacing: 20) {
                                ForEach(resultHandler.results, id: \.self) { item in
                                    ResultRow(resultItem: item)
                                }
                            }
                        }
                        .frame(maxHeight: metrics.size.height * 0.5)
                        if resultHandler.gotSpeedBonus() == true {
                            Divider()
                            HStack {
                                Text("Speed bonus")
                                    .foregroundColor(Color.theme.rankingUp)
                                Spacer()
                                Text("x\(resultHandler.speedBonus, specifier: "%.2f")")
                            }
                            .font(Font.customFont.normalText)
                            .padding(.vertical)
                        }
                        Divider()
                        HStack {
                            Text("Total")
                            Spacer()
                            Text(String(resultHandler.score))
                        }
                        .font(Font.customFont.largeText)
                        .foregroundColor(Color.theme.background)
                        .padding(.vertical)
                    }
                    .padding()
                    .padding(.top)
                    .frame(minHeight: metrics.size.height * 0.6)
                    .background(Color.white)
                    .cornerRadius(30)
                    .shadow(color: .gray, radius: 2, x: 0, y: 3)
                    .transition(.slide)
                    
                    HStack (alignment: .center) {
                        Button("Continue") {
                            challengeInfoOpened = false
                        }
                        .padding(.vertical, 10)
                        .frame(width: 200)
                        .background(Color.theme.button)
                        .foregroundColor(Color.white)
                        .cornerRadius(40)
                    }
                    .frame(maxHeight: .infinity)
                    .transition(.fade)
                }
            }
            .padding(.horizontal)
            .onAppear {
                play(sound: "success.mp3")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        showScore = true
                    }                    
                }
            }
        }
    }
}

struct ChallengeCompleted_Previews: PreviewProvider {
    static var previews: some View {
        let results = [
            ResultItem(text: "Test1", comment: "blablablabla", score: 20),
            ResultItem(text: "Test1", score: 20),
            ResultItem(text: "Test1", score: 20),
            ResultItem(text: "Test1", comment: "blablablabla", score: 20)
        ]
        ChallengeCompleted(challengeInfoOpened: .constant(true), resultHandler: .constant(ResultHandler(results: results)), revealedChallenge: .constant(true))
    }
}
