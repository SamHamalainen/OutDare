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
        GeometryReader { metrics in
            HStack (alignment: .top) {
                Text(resultItem.text)
                    .frame(width: metrics.size.width * 0.6, alignment: .leading)
                Text(getPercentage())
                    .frame(width: metrics.size.width * 0.2)
                Text("\(resultItem.score, specifier: "%.2f")")
                    .frame(maxWidth:.infinity, alignment: .trailing)
            }
            .font(Font.customFont.normalText)
            .lineLimit(2)
        }
    }
}

extension ResultRow {
    func getPercentage() -> String {
        if let percentage = resultItem.percentage {
            return "\(percentage)%"
        } else {
            return ""
        }
    }
}

//struct ResultRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultRow()
//    }
//}
