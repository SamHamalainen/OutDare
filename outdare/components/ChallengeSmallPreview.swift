//
//  ChallengePreview.swift
//  quiz
//
//  Created by iosdev on 2.4.2022.
//

import SwiftUI

struct ChallengeSmallPreview: View {
    let logoName: String
    let title: String
    let difficulty: String
    let points: Int
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Image(systemName: logoName)
                    .resizable()
                    .frame(width: 30.0, height: 30.0)
                    .padding(.top, 2)
                VStack(alignment: .leading) {
                    Text(title)
                    Text(difficulty)
                        .font(.subheadline)
                }
                Spacer()
                Text("+\(points)")
                    .font(.caption)
                    .padding(.trailing)
            }
            Divider()
        }
        .padding(.horizontal)
    }
}

struct ChallengeSmallPreview_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeSmallPreview(logoName: "questionmark.circle", title: "Quiz", difficulty: "Easy", points: 20)
    }
}
