//
//  ChallengeDetailedPreview.swift
//  quiz
//
//  Created by iosdev on 2.4.2022.
//

import SwiftUI
import CoreLocation
import Speech

/// View that shows the detailed information of a challenge and awaits the input of the user to start a countdown to the start of the challenge
///
/// In this view, the users are also prompted to authorize Speech Recognition if they haven't yet.
struct ChallengeDetailedPreview: View {
    let challenge: Challenge
    @Binding var state: ChallengeState
    @State var ready = false
    @State var countdownOver = false
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
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
                            checkSRPermission()
                        }) {
                            Text("I'm ready!")
                                .padding(.vertical, 10)
                                .frame(width: 200)
                                .background(Color.theme.button)
                                .foregroundColor(Color.white)
                                .cornerRadius(40)
                        }
                        // Alert that prompts the user to authorize Speech Recognition
                        .alert("Speech Recognition permission is needed to complete challenges. Please authorize it in app settings", isPresented: $showingAlert) {
                            Button("Go to settings") { UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!) }
                            Button("Cancel", role: .cancel) { }
                        }
                    } else {
                        CountdownTimer(timer: 3, over: $countdownOver)
                            .onChange(of: countdownOver) { over in
                                if over {
                                    state = .playing
                                }
                            }
                    }
                }
                .padding(.bottom, 35)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
}

extension ChallengeDetailedPreview {
    /// Checks the permisson for Speech Recognition. If allowed, the countdown to the challenge will start, else an alert pops up.
    ///
    /// Quizzes do not require Speech Recognition
    func checkSRPermission() {
        if SFSpeechRecognizer.authorizationStatus() == .authorized || challenge.category == .quiz {
            ready = true
        } else {
            showingAlert = true
        }
    }
}

struct ChallengeDetailedPreview_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailedPreview(challenge: Challenge.sample[0], state: .constant(.awaiting))
    }
}
