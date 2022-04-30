//
//  ResultRow.swift
//  outdare
//
//  Created by iosdev on 24.4.2022.
//

import SwiftUI

struct ResultRow: View {
    let resultItem: ResultItem 
    var body: some View {
        HStack (alignment: .top) {
            VStack (alignment: .leading) {
                Text(resultItem.text)
                    .font(Font.customFont.normalText)
                    .fontWeight(.bold)
                    
                if let comment = resultItem.comment {
                    Text("\t\(comment)")
                        .font(Font.customFont.smallText)
                }
            }
            Spacer()
            Text("\(resultItem.score, specifier: "%.2f")")
                .font(Font.customFont.normalText)
        }
    }
}

//struct ResultRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultRow()
//    }
//}
