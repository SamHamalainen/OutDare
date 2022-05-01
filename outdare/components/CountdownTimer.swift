//
//  CountdownTimer.swift
//  quiz
//
//  Created by iosdev on 2.4.2022.
//

import SwiftUI
import Subsonic

struct CountdownTimer: View {
    @State var timer: Int
    @Binding var over: Bool
    let countdown = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        Text("\(timer == 0 ? "Go!" : String(timer))")
            .font(.title)
            .onReceive(countdown) {_ in
                if timer > 0 {
                    if !UserDefaults.standard.bool(forKey: "mute") {
                        play(sound: "countdown.wav")
                    }
                    timer -= 1
                } else {
                    if !UserDefaults.standard.bool(forKey: "mute") {
                        play(sound: "start.wav")
                    }
                    over = true
                }
            }
            .onAppear {
                if !UserDefaults.standard.bool(forKey: "mute") {
                    play(sound: "countdown.wav")
                }
            }
    }
}

//struct CountdownTimer_Previews: PreviewProvider {
//    static var previews: some View {
//        CountdownTimer(timer: 5, countdownOver: {_ in})
//    }
//}
