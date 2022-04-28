//
//  SelectList.swift
//  outdare
//
//  Created by iosdev on 29.4.2022.
//

import SwiftUI

struct SelectList: View {
    @Binding var selected: [TriviaQuestion]
    let questions: [TriviaQuestion]
    var limit = 5
    var body: some View {
    
        VStack {
            Text("Select \(limit) questions to create a quiz")
                .font(Font.customFont.normalText)
                .padding(.vertical)
            Text("\(selected.count) selected")
                .font(Font.customFont.smallText)
                .padding(.bottom)
            ScrollView {
                VStack {
                    ForEach(questions, id: \.self) { q in
                        let isSelected = selected.contains(q)
                        Button(action: {
                            if !isSelected {
                                if selected.count < 5 {
                                    let newSelected = selected + [q]
                                    selected = newSelected
                                }
                            } else {
                                if let index = selected.firstIndex(of: q) {
                                    var newSelected = selected
                                    newSelected.remove(at: index)
                                    selected = newSelected
                                }
                            }
                        }) {
                            Text(q.question)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(isSelected ? Color.theme.background : Color.theme.backgroundOverlay)
                                .foregroundColor(isSelected ? Color.white : Color.theme.textDark)
                                .font(Font.customFont.smallText)
                                .multilineTextAlignment(.leading)
                                .cornerRadius(20)
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

//struct SelectList_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectList()
//    }
//}
