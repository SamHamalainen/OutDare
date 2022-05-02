//
//  PointPurchaseItem.swift
//  outdare
//
//  Created by Sam Hämäläinen on 26.4.2022.
//  Description: List item in the PointPurchacingView

import SwiftUI

struct PointPurchaseItem: View {
    private var pointAmount: Int
    private var icon: String
    
    init(pointAmount: Int, icon: String) {
        self.pointAmount = pointAmount
        self.icon = icon
    }
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color("Background2"))
                .frame(width: 175, height: 225)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.8), radius: 10)
            Circle()
                .trim(from: 0.5, to: 1)
                .frame(width: 155, height: 155)
                .foregroundColor(Color(red: 255, green: 255, blue: 255, opacity: 0.5))
                .blur(radius: 50)
                .offset(y:50)
            VStack {
                Image("\(icon)")
                    .resizable()
                .frame(width: 100, height: 100)
                Text("\(pointAmount) Points")
                    .font(Font.customFont.challengeDescription)
                    .fontWeight(.bold)
                ZStack {
                    Rectangle()
                        .frame(width: 175, height: 50)
                    .opacity(0.1)
                    Text("FREE")
                        .font(Font.customFont.extraLargeText)
                }
            }
        }
        
    }
}

struct PointPurchaseItem_Previews: PreviewProvider {
    static var previews: some View {
        PointPurchaseItem(pointAmount: 500, icon: "coin")
    }
}
