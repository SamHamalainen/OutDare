//
//  QuizGeneratorView.swift
//  outdare
//
//  Created by iosdev on 28.4.2022.
//

import SwiftUI

struct QuizGeneratorView: View {
    @StateObject var dao = TriviaApiDao()
    let defCatVal = "Choose a category"
    let defDifVal = "Choose a difficulty"
    @State var category: String = "Choose a category"
    @State var difficulty: String = "Choose a difficulty"
    @State var selected: [TriviaQuestion] = []
    @State var showForm = false
    
    func reset() {
        selected = []
        dao.loading = nil
        category = defCatVal
        difficulty = defDifVal
    }
    
    var body: some View {
        let categories = [defCatVal] + dao.quizCategories.keys.sorted(by: {$0<$1})
        let btnWidth = UIScreen.main.bounds.width * 0.35
        ZStack {
            if showForm {
                CreateQuizForm(showForm: $showForm, selected: $selected)
                    .zIndex(1)
                    .transition(.move(edge: .bottom))
            }
            
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
                    
                    VStack(spacing: 20){
                            VStack {
                                Picker("Please choose a category", selection: $category) {
                                    ForEach(categories, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .colorMultiply(Color.black)
                            }
                            .padding(.horizontal)
                            .background(Color.theme.backgroundOverlay)
                            .cornerRadius(30)
                            
                            VStack {
                                Picker(selection: $difficulty, label: Text("Please choose a difficulty")) {
                                    ForEach(["Choose a difficulty", "easy", "medium", "hard"], id: \.self) {
                                        Text($0.capitalizingFirstLetter())
                                    }
                                }
                                .colorMultiply(Color.black)
                            }
                            .padding(.horizontal)
                            .background(Color.theme.backgroundOverlay)
                            .cornerRadius(30)
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
                                withAnimation {
                                    showForm = true
                                }                                
                            }) {
                                Text("Create")
                                    .padding(.vertical, 10)
                                    .frame(width: btnWidth)
                                    .font(Font.customFont.btnText)
                                    .background(Color.theme.background)
                                    .foregroundColor(Color.white)
                                    .cornerRadius(40)
                                
                            }
                        }
                    }
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.theme.background2)
                .cornerRadius(30)
                .transition(.slide)
            }
            .padding()
        }
    }
}

struct QuizGeneratorView_Previews: PreviewProvider {
    static var previews: some View {
        QuizGeneratorView()
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
