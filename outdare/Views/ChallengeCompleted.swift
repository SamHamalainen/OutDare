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
   
    var body: some View {
        GeometryReader { metrics in
            VStack {
                Text("Challenge completed")
                    .padding()
                    .font(Font.customFont.largeText)
                VStack {
                    ScrollView {
                        ForEach(resultHandler.results, id: \.self) { item in
                            ResultRow(resultItem: item)
                                .frame(maxHeight: 60)
                                .padding(.bottom)
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
            }
            .padding(.horizontal)
        }
    }
}

//struct ChallengeCompleted_Previews: PreviewProvider {
//    static var previews: some View {
//        let results = [
//            ResultItem(text: "Test1 loooooo ooooooooo", score: 20),
//            ResultItem(text: "Test1", score: 20),
//            ResultItem(text: "Test1", score: 20),
//            ResultItem(text: "Test1", score: 20)
//        ]
//        ChallengeCompleted(challengeInfoOpened: .constant(true), resultHandler: .constant(ResultHandler(results: results, time: 5, maxTime: 8)), revealedChallenge: $revealedChallenge)
//    }
//}
