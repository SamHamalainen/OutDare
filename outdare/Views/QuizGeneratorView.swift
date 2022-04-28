//
//  QuizGeneratorView.swift
//  outdare
//
//  Created by iosdev on 28.4.2022.
//

import SwiftUI

struct QuizGeneratorView: View {
    @StateObject var dao = TriviaApiDao()
    let btnWidth = UIScreen.main.bounds.width * 0.35
    let btnSpacing = UIScreen.main.bounds.width * 0.1
    let defCatVal = "Choose a category"
    let defDifVal = "Choose a difficulty"
    @State var category: String = "Choose a category"
    @State var difficulty: String = "Choose a difficulty"
    @State var selected: [TriviaQuestion] = []
    
    func test() {
        let difficulties = ["easy", "medium", "hard"]
        for c in quizCategories.keys {
            for d in difficulties {
                dao.generateQuestions(categoryName: c, difficulty: d)
            }
        }
    }
    
    var body: some View {
        let categories = [defCatVal] + dao.quizCategories.keys.sorted(by: {$0<$1})
        
        VStack {
            
            if let loading = dao.loading {
                Spacer()
                if loading {
                    ProgressView()
                } else {
                    if dao.fetchedQuestions.count >= 5 {
                        SelectList(selected: $selected, questions: dao.fetchedQuestions)
                    } else {
                        Text("Not enough questions 😕\nPlease try other parameters")
                    }
                }
                Spacer()
            }
            
            VStack {
                Text("Quiz Generator")
                    .font(Font.customFont.largeText)
                    .padding()
                
                HStack {
                    VStack {
                        Picker("Please choose a category", selection: $category) {
                            ForEach(categories, id: \.self) {
                                Text($0)
                            }
                        }
                        
                        Picker("Please choose a difficulty", selection: $difficulty) {
                            ForEach(["Choose a difficulty", "easy", "medium", "hard"], id: \.self) {
                                Text($0)
                            }
                        }
                    }
                    
                }
                .padding(.bottom)
                
                HStack {
                    if category != defCatVal && difficulty != defDifVal {
                        Button(action: {
                            selected = []
                            withAnimation {
                                dao.generateQuestions(categoryName: category, difficulty: difficulty)
                            }
                        }) {
                            Text("Generate")
                                .padding(.vertical, 10)
                                .frame(width: btnWidth)
                                .font(Font.customFont.btnText)
                                .background(Color.theme.button)
                                .foregroundColor(Color.white)
                                .cornerRadius(40)
                        }
                    }
                    
                    if selected.count == 5 {
                        Button(action: {
                        }) {
                            Text("Submit")
                                .padding(.vertical, 10)
                                .frame(width: btnWidth)
                                .font(Font.customFont.btnText)
                                .background(Color.theme.button)
                                .foregroundColor(Color.white)
                                .cornerRadius(40)
                            
                        }
                    }
                }
                
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.theme.background2)
            .cornerRadius(40)
            .shadow(color: .gray, radius: 2, x: 0, y: 3)
        }
        .padding()
    }
}

struct QuizGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        QuizGeneratorView()
    }
}
