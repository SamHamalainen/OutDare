//
//  ChallengeCount.swift
//  quiz
//
//  Created by iosdev on 3.4.2022.
//

import SwiftUI

/// Indicator that shows the progress of the user into the challenge e.g. 4 questions out of 5
struct ChallengeCount: View {
    let index: Int
    let limit: Int
    var body: some View {
        HStack {
            ForEach(1..<limit + 1) { num in
                Text("\(num)")
                    .frame(maxWidth: 20)
                    .background(num - 1 == index ? Color.theme.background : Color.theme.icon)
                    .foregroundColor(Color.white)
                    .cornerRadius(.infinity)
            }
        }
    }
}

struct ChallengeCount_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeCount(index: 0, limit: 5)
    }
}
