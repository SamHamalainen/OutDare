//
//  QuizGeneratorView.swift
//  outdare
//
//  Created by iosdev on 28.4.2022.
//

import SwiftUI

/// View that allows the user to generate trivia questions fetched from opentdb.com.
///
/// After choosing a category and a difficulty level, the user can generate and choose 5 questions from the generated list to create a new quiz.
struct QuizGeneratorView: View {
    @StateObject var dao = TriviaApiDao()
    let defCatVal = "Choose a category"
    let defDifVal = "Choose a difficulty"
    @State var category: String = "Choose a category"
    @State var difficulty: String = "Choose a difficulty"
    @State var selected: [TriviaQuestion] = []
    @State var showForm = false
    
    var body: some View {
        let categories = [defCatVal] + dao.quizCategories.keys.sorted(by: {$0<$1})
        let btnWidth = UIScreen.main.bounds.width * 0.35
        ZStack {
            // Shows the form where the user can input title, description and location for the quiz
            if showForm {
                CreateQuizForm(showForm: $showForm, selected: $selected)
                    .zIndex(1)
                    .transition(.move(edge: .bottom))
            }
            // Shows a loading animation if the list is being fetched from opentdb.com, else the list of trivia questions is displayed from which the user can select 5 questions before opening the CreateQuizForm
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
                
                // View with the pickers for category and difficulty
                VStack {
                    Text("Quiz Generator")
                        .font(Font.customFont.largeText)
                        .padding()
                    
                    VStack(spacing: 20){
                            VStack {
                                Picker(LocalizedStringKey("Please choose a category"), selection: $category) {
                                    ForEach(categories, id: \.self) {
                                        Text(LocalizedStringKey($0))
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
                                        Text(LocalizedStringKey($0.capitalizingFirstLetter()))
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
    
    /// Function which return a string with a capitalized first letter
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
