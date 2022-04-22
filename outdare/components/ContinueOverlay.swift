//
//  ContinueOverlay.swift
//  outdare
//
//  Created by iosdev on 20.4.2022.
//

import SwiftUI

struct ContinueOverlay: View {
    @Binding var message: String
    @Binding var index: Int
    @Binding var correct: Bool
    var lastIndex: Int
    var action: () -> Void
    var body: some View {
        Rectangle()
            .ignoresSafeArea()
            .opacity(0.45)
            .zIndex(1)
        VStack() {
            Spacer()
            VStack(spacing: 40) {
                Text(message)
                    .font(Font.customFont.largeText)
                    .padding(.top, 30)
                    .multilineTextAlignment(.center)
                    .foregroundColor(correct ? Color.theme.rankingUp : Color.theme.textDark)
                Button(action: { action() }) {
                    Text((index != lastIndex) ? "Continue" : "Finish")
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
            .background(Color.white)
            .cornerRadius(20)
        }
        .zIndex(2)
        .ignoresSafeArea()
        .transition(.move(edge: .bottom))
    }
}

struct ContinueOverlay_Previews: PreviewProvider {
    static var previews: some View {
        ContinueOverlay(message: .constant("Ready?"), index: .constant(3), correct: .constant(true), lastIndex: 4, action: {})
    }
}
