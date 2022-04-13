//
//  CountdownTimer.swift
//  quiz
//
//  Created by iosdev on 2.4.2022.
//

import SwiftUI

struct CountdownTimer: View {
    @State var timer: Int
    let countdownOver: (Bool) -> Void
    let countdown = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        Text("\(timer)")
            .font(.title)
            .onReceive(countdown) {_ in
                if timer > 0 {
                    timer -= 1
                } else {
                    countdownOver(true)
                }
            }
    }
}

struct CountdownTimer_Previews: PreviewProvider {
    static var previews: some View {
        CountdownTimer(timer: 5, countdownOver: {_ in})
    }
}
