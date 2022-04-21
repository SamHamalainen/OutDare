//
//  ChallengeDetailedPreview.swift
//  quiz
//
//  Created by iosdev on 2.4.2022.
//

import SwiftUI
import CoreLocation
import Speech

struct ChallengeDetailedPreview: View {
    let challenge: Challenge
    let notifyParent2: () -> Void
    let setState: (String) -> Void
    @State var ready = false
    
    @State private var showingAlert = false
    
    func notifyParent(countDownOver: Bool) {
        if countDownOver {
            setState("playing")
            notifyParent2()
        }
    }
    
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
                            if checkSRPermission() {
                                ready = true
                            } else {
                                checkSRPermission()
                            }
                            
                        }) {
                            Text("I'm ready!")
                                .padding(.vertical, 10)
                                .frame(width: 200)
                                .background(Color.theme.button)
                                .foregroundColor(Color.white)
                                .cornerRadius(40)
                        }
                        .alert("Speech Recognition permission is needed to complete challenges", isPresented: $showingAlert) {
                            Button("Go to settings") { UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!) }
                            Button("Cancel", role: .cancel) { }
                        }
                    } else {
                        CountdownTimer(timer: 3, countdownOver: notifyParent)
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
    func checkSRPermission() -> Bool {
        guard SFSpeechRecognizer.authorizationStatus() == .authorized else {
            SFSpeechRecognizer.requestAuthorization({ (status) in
                print("Need speech recognition authorization")
                if status != .notDetermined {
                    showingAlert = true
                }
            })
            return false
        }
        return true
    }
}

struct ChallengeDetailedPreview_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailedPreview(challenge: Challenge(id: 1, challengeId: 1, name: "quizzz", difficulty: "easy", category: "quiz", description: "Answer these 5 super easy questions you have 10 seconds per question.", coordinates: CLLocationCoordinate2D(latitude: 60.224810974873215, longitude: 24.75657413146672)), notifyParent2: {}, setState: {_ in})
    }
}
