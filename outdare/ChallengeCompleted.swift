//
//  ChallengeCompleted.swift
//  quiz
//
//  Created by iosdev on 4.4.2022.
//

import SwiftUI

struct ChallengeCompleted: View {
    @Binding var challengeInfoOpened: Bool
    let score: Int
    let time: Double
    var body: some View {
        VStack {
            Text("Challenge completed")
                .padding()
            HStack {
                Text("Score")
                Spacer()
                Text("\(score)/5")
            }
            HStack {
                Text("Time")
                Spacer()
                Text("\(Int(ceil(time)))/50")
            }
            Spacer()
            Button("Continue") {
                challengeInfoOpened = false
            }
            .padding(.vertical, 10)
            .frame(width: 200)
            .background(Color.theme.button)
            .foregroundColor(Color.white)
            .cornerRadius(40)
        }
        .padding()
    }
}
//
//struct ChallengeCompleted_Previews: PreviewProvider {
//    static var previews: some View {
//        ChallengeCompleted(challengeInfoExpanded: true, score: 0, time: 0.0)
//    }
//}
