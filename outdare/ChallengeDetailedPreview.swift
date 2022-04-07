//
//  ChallengeDetailedPreview.swift
//  quiz
//
//  Created by iosdev on 2.4.2022.
//

import SwiftUI

struct ChallengeDetailedPreview: View {
    let challenge: Challenge
    let setState: (String) -> Void
    @State var ready = false
    func notifyParent(countDownOver: Bool) {
        if countDownOver {
            setState("playing")
        }
    }
    
    var body: some View {
        VStack {
            ChallengeSmallPreview(logoName: challenge.logoName, title: challenge.name, difficulty: challenge.difficulty, points: challenge.points)
            Spacer()
            VStack {
                Spacer()
                Text("Get ready!")
                    .font(.headline)
                    .padding()
                Text(challenge.description)
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
                Group {
                    if !ready {
                        Button(action: {
                            ready = true
                        }) {
                            Text("I'm ready!")
                                .padding(.vertical, 10)
                                .frame(width: 200)
                                .background(Color.theme.button)
                                .foregroundColor(Color.white)
                                .cornerRadius(40)
                        }
                    } else {
                        CountdownTimer(timer: 3, countdownOver: notifyParent)
                    }
                }
                .padding(.bottom)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

struct ChallengeDetailedPreview_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailedPreview(challenge: Challenge.sample[0], setState: {_ in})
    }
}
