//
//  ContinueOverlay.swift
//  outdare
//
//  Created by iosdev on 20.4.2022.
//

import SwiftUI
import Subsonic

struct ContinueOverlay: View {
    var message: String
    var index: Int
    var correct: Bool
    var length: Int
    var action: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 40) {
                Text(LocalizedStringKey(message))
                    .font(Font.customFont.largeText)
                    .padding(.top, 30)
                    .multilineTextAlignment(.center)
                    .foregroundColor(correct ? Color.theme.rankingUp : Color.theme.textDark)
                Button(action: { action() }) {
                    Text((index != length - 1) ? "Continue" : "Finish")
                }
                .padding(.vertical, 10)
                .frame(width: 200)
                .font(Font.customFont.btnText)
                .background(Color.theme.background)
                .foregroundColor(Color.white)
                .cornerRadius(40)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 50)
            .padding(.horizontal)
            .background(Color.theme.background2)
            .cornerRadius(20)
        }
        .zIndex(2)
        .ignoresSafeArea()
        .transition(.move(edge: .bottom))
        .onAppear {
            if correct && !UserDefaults.standard.bool(forKey: "mute") {
                play(sound: "correct.mp3")
            }
        }
    }
}

struct ContinueOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ContinueOverlay(message: "Ready?", index: 3, correct: true, length: 4, action: {})
    }
}
