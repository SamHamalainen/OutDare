//
//  QuizUI.swift
//  quiz
//
//  Created by iosdev on 2.4.2022.
//

import SwiftUI

//struct QuizUI: View {
//    let quizData: QuizData
//    let timeout: Double
//    @State var selectedAns: String? = nil
//    let onAnswer: (String) -> Void
//    
//    func handleAns(ans: String) {
//        selectedAns = ans
//        onAnswer(ans)
//        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) {
//            selectedAns = nil
//        }
//    }
//    
//    var body: some View {
//        VStack {
//            Text(quizData.question)
//                .frame(maxWidth: .infinity, maxHeight: 100)
//                .background(Color.orange)
//                .foregroundColor(Color.white)
//                .cornerRadius(20)
//                .padding(.bottom)
//                
//            VStack {
//                ForEach(quizData.answers, id: \.self) { ans in
//                    Button(action: {handleAns(ans: ans)}) {
//                        Text(ans)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background((selectedAns != nil && ans == quizData.correctAns) ? Color.green : (selectedAns == ans && ans != quizData.correctAns) ? Color.red : Color.gray)
//                            .foregroundColor(Color.white)
//                            .cornerRadius(20)
//                    }
//                    .disabled(selectedAns != nil)
//                }
//            }
//        }
//        .padding(.horizontal)
//    }
//}
//
//struct QuizUI_Previews: PreviewProvider {
//    static var previews: some View {
//        QuizUI(quizData: Quiz.sample[0].data[0], timeout: 2.0, onAnswer: {_ in})
//    }
//}
