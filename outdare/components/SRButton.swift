//
//  SRButton.swift
//  outdare
//
//  Created by iosdev on 12.4.2022.
//

import SwiftUI

struct SRButton: View {
    @ObservedObject var speechAnalyzer: SpeechAnalyzer
    let size: CGFloat = 50
    
    @State var isAtMinScale = false
    private let animation = Animation.easeInOut(duration: 0.6)
    private let minScale = 0.8
    
    var body: some View {
        VStack {
            Button(action: {toggleSpeechRecognition()}) {
                    Image(systemName: speechAnalyzer.isProcessing ? "mic.fill" : "mic")
                        .resizable()
                        .foregroundColor(speechAnalyzer.isProcessing ? Color.theme.background : Color.theme.icon)
                        .scaledToFit()
                        .frame(width: size, height: size)
                        .padding(50)
                        .overlay(
                            Circle()
                                .stroke(speechAnalyzer.isProcessing ? Color.theme.background : Color.theme.icon, lineWidth: 5)
                                .scaleEffect(isAtMinScale ? minScale : 1)
                                .onChange(of: speechAnalyzer.isProcessing) { bool in
                                    withAnimation(bool ? animation.repeatForever() : animation, {
                                        isAtMinScale.toggle()
                                    })
                                }
                        )
            }
            HStack (spacing: 10) {
                if speechAnalyzer.isProcessing {
                    ProgressView()
                }
                Text(speechAnalyzer.isProcessing ? "Listening" : "Tap to speak")
                    .foregroundColor(speechAnalyzer.isProcessing ? Color.theme.background : Color.theme.icon)
            }
        }
    }
}

extension SRButton {
    func toggleSpeechRecognition() {
        if speechAnalyzer.isProcessing {
            speechAnalyzer.stop()
        } else {
            speechAnalyzer.start()
        }
    }
}
    
//struct SRButton_Previews: PreviewProvider {
//    static var previews: some View {
//        SRButton()
//    }
//}
