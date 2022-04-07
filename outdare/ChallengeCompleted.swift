//
//  ChallengeCompleted.swift
//  quiz
//
//  Created by iosdev on 4.4.2022.
//

import SwiftUI

struct ChallengeCompleted: View {
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
        }
        .padding()
    }
}

struct ChallengeCompleted_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCompleted(score: 0, time: 0.0)
    }
}
