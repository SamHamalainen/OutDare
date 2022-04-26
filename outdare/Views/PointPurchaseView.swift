//
//  PointPurchaseView.swift
//  outdare
//
//  Created by Sam Hämäläinen on 26.4.2022.
//

import SwiftUI

struct PointOrdered: Identifiable {
    var id: String { name }
    let name: String
    let points: Int
    let price: String
}

struct PointPurchaseView: View {
    @State private var selectedItem: PointOrdered?
    @EnvironmentObject var vm: AppViewModel
    
    var body: some View {
        ZStack {
            VStack (spacing: 30) {
                VStack (alignment: .center, spacing: 1) {
                    Text("Point Store")
                        .font(Font.customFont.countdown)
                    .foregroundColor(.white)
                    Rectangle()
                        .fill(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: 2)
                }
                HStack (spacing: 15) {
                    PointPurchaseItem(pointAmount: 500, icon: "coin")
                        .onTapGesture {
                            selectedItem = PointOrdered(name: "smallest", points: 500, price: "FREE")
                            vm.userDao.getLoggedInUserScore()
                        }
                    PointPurchaseItem(pointAmount: 2500, icon: "money")
                        .onTapGesture {
                            selectedItem = PointOrdered(name: "medium", points: 2500, price: "FREE")
                            vm.userDao.getLoggedInUserScore()
                        }
                }
                HStack (spacing: 15) {
                    PointPurchaseItem(pointAmount: 5000, icon: "coins")
                        .onTapGesture {
                            selectedItem = PointOrdered(name: "large", points: 5000, price: "FREE")
                            vm.userDao.getLoggedInUserScore()
                        }
                    PointPurchaseItem(pointAmount: 10000, icon: "gold-ingots")
                        .onTapGesture {
                            selectedItem = PointOrdered(name: "mega", points: 10000, price: "FREE")
                            vm.userDao.getLoggedInUserScore()
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("Background"))
        .alert(item: $selectedItem) { item in
            Alert(
                title: Text("Purchace \(item.points) points?"),
                message: Text("By purchasing this item, \(item.points) points will be added to your accounts points."),
                primaryButton: .default(Text("Purchase")) {
                    if let userScore = vm.userDao.loggedUserScore {
                        vm.userDao.updateUsersScore(newScore: userScore + item.points)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

struct PointPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PointPurchaseView()
        }
    }
}
