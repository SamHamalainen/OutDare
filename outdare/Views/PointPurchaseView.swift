//
//  PointPurchaseView.swift
//  outdare
//
//  Created by Sam Hämäläinen on 26.4.2022.
//  Description: View for purchasing more points.

import SwiftUI

// Selected item for purchase
struct PointOrdered: Identifiable {
    var id: String { name }
    let name: String
    let points: Int
    let price: String
}

struct PointPurchaseView: View {
    @State private var selectedItem: PointOrdered?
    @State private var pointsPopUp: Int = 0
    @State private var popUpVisible: Bool = false
    @EnvironmentObject var vm: AppViewModel
    
    func closePopUp() {
        popUpVisible = false
    }
    
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
                    PointPurchaseItem(pointAmount: 50, icon: "coin")
                        .onTapGesture {
                            selectedItem = PointOrdered(name: "smallest", points: 50, price: "FREE")
                            vm.userDao.getLoggedInUserScore()
                        }
                    PointPurchaseItem(pointAmount: 100, icon: "money")
                        .onTapGesture {
                            selectedItem = PointOrdered(name: "medium", points: 100, price: "FREE")
                            vm.userDao.getLoggedInUserScore()
                        }
                }
                HStack (spacing: 15) {
                    PointPurchaseItem(pointAmount: 250, icon: "coins")
                        .onTapGesture {
                            selectedItem = PointOrdered(name: "large", points: 250, price: "FREE")
                            vm.userDao.getLoggedInUserScore()
                        }
                    PointPurchaseItem(pointAmount: 500, icon: "gold-ingots")
                        .onTapGesture {
                            selectedItem = PointOrdered(name: "mega", points: 500, price: "FREE")
                            vm.userDao.getLoggedInUserScore()
                        }
                }
            }
            .allowsHitTesting(!popUpVisible)
            
            // When selected item, view it with correct details
            if popUpVisible {
                ZStack {
                    ZStack (alignment: .top) {
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color("Background"))
                        VStack {
                            Text("Points added!")
                                .font(Font.customFont.extraLargeText)
                                .foregroundColor(.white)
                                .padding(.top, 15)
                            Rectangle()
                                .fill(.white)
                                .frame(width: UIScreen.main.bounds.width * 0.7, height: 2)
                            Text("\(pointsPopUp) points has been added to your account.")
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: 100)
                                .foregroundColor(.white)
                            Button(action: closePopUp) {
                                Text("OK")
                                    .frame(width: 100, height: 30)
                                    .background(Color("Button"))
                                    .cornerRadius(25)
                                    .foregroundColor(.white)
                            }
                            .padding(.bottom, 15)
                        }
                    }
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(.black, lineWidth: 3)
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 200)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color("Background"))
        .alert(item: $selectedItem) { item in
            Alert(
                title: Text("Purchace \(item.points) points?"),
                message: Text("By purchasing this item, \(item.points) points will be added to your accounts points."),
                primaryButton: .default(Text("Purchase")) {
                    pointsPopUp = item.points
                    popUpVisible = true
                    vm.userDao.updateUsersScore(newScore: item.points)
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
