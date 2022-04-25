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
    @Binding var state: String
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
                        .alert("Speech Recognition permission is needed to complete challenges", isPresented: $showingAlert) {
                            Button("Go to settings") { UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!) }
                            Button("Cancel", role: .cancel) { }
                        }
                    } else {
                        CountdownTimer(timer: 3, over: $countdownOver)
                            .onChange(of: countdownOver) { over in
                                if over {
                                    state = "playing"
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
    func checkSRPermission() {
        if SFSpeechRecognizer.authorizationStatus() == .authorized {
            ready = true
        } else {
            SFSpeechRecognizer.requestAuthorization({ (status) in
                print("Need speech recognition authorization")
                if status != .notDetermined {
                    showingAlert = true
                }
            })
        }
    }
}

//struct ChallengeDetailedPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        ChallengeDetailedPreview(challenge: Challenge(id: 1, challengeId: 1, name: "quizzz", difficulty: "easy", category: "quiz", description: "Answer these 5 super easy questions you have 10 seconds per question.", coordinates: CLLocationCoordinate2D(latitude: 60.224810974873215, longitude: 24.75657413146672)), notifyParent2: {}, setState: {_ in})
//    }
//}
