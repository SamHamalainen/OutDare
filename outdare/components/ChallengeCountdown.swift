//
//  ChallengeCountdown.swift
//  quiz
//
//  Created by iosdev on 2.4.2022.
//

import SwiftUI

//struct ChallengeCountdown: View {
//    let headline: String
//    let instructions: String
//    @State var ready = false
//    
//    var body: some View {
//        VStack {
//            Spacer()
//            Text(headline)
//                .font(.headline)
//                .padding()
//            Text(instructions)
//                .font(.subheadline)
//                .multilineTextAlignment(.center)
//                .padding()
//            Spacer()
//            Group {
//                if !ready {
//                    Button(action: {
//                        ready = true
//                    }) {
//                        Text("I'm ready!")
//                            .padding(.vertical, 10)
//                            .frame(width: 200)
//                            .background(Color.gray)
//                            .foregroundColor(Color.white)
//                            .cornerRadius(40)
//                    }
//                } else {
//                    CountdownTimer(timer: 3)
//                }
//            }
//            .padding(.bottom)
//        }
//        .padding(.horizontal)
//    }
//}
//
//struct ChallengeCountdown_Previews: PreviewProvider {
//    static var previews: some View {
//        ChallengeCountdown(headline: "Get ready!", instructions: "Answer these 5 super easy geography questions. You have 7 seconds per question.")
//    }
//}
