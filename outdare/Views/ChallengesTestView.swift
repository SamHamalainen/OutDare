////
////  ChallengesTestView.swift
////  outdare
////
////  Created by iosdev on 6.4.2022.
////
//
//import SwiftUI
//
//struct ChallengesTestView: View {
//
//    @StateObject var dao = ChallengeDAO()
//
//    var body: some View {
//        Group {
//            if dao.challenges.isEmpty {
//                Text("No challenges")
//            } else {
//                NavigationView {
//                    List(dao.challenges, id: \.id) { challenge in
//                        if let challenge = challenge {
//                            NavigationLink(destination: ChallengeContainer(challenge: challenge)) {
//                                ChallengeSmallPreview(logoName: "questionmark.circle", title: challenge.name, difficulty: challenge.difficulty, points: challenge.points)
//                            }
//                            .padding(.vertical)
//                        }
//                    }
//                }
//
//            }
//        }
//        .onAppear(){
//            dao.getChallenges()
//        }
//    }
//}
//
//struct ChallengesTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChallengesTestView()
//    }
//}
