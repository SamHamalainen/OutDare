//
//  DirectionsList.swift
//  outdare
//
//  Created by Tatu Ihaksi on 27.4.2022.
//

import SwiftUI
/// View component which shows the directions info and challenges in a scrollview
struct DirectionsList: View {
    @ObservedObject var navigationRoute: NavigationRoute
    
    var body: some View {
        ScrollView {
            HStack {
                Image("chuckTheChick").resizable().scaledToFit().frame(width: 50, height: 70)
                Spacer()
            }
            ForEach(navigationRoute.directionsArray) { directions in
                directionsInfo(directions: directions)
                challengeInfo(directions: directions)
            }
        }
    }
    private func normalText(_ text: String) -> some View {
        Text(text).font(Font.customFont.normalText)
    }
    /// View that shows directions distance and time
    private func directionsInfo(directions: Directions) -> some View {
        HStack {
            VStack {
                Image(systemName: "arrow.down").resizable().scaledToFit().frame(width: 30, height: 30)
            }.frame(width: 50)
            
            HStack {
                Image(systemName: "clock")
                normalText(DirectionsView.formattedTime(of: directions.mkRoute.expectedTravelTime))
                Image(systemName: "arrow.left.and.right")
                normalText(DirectionsView.formattedDistance(of: directions.mkRoute.distance))
            }.padding()
            Spacer()
        }
    }
    /// View that shows challenges name, icon and also button for removing challenge from the route
    private func challengeInfo(directions: Directions) -> some View {
        HStack {
            Image(directions.destination.icon).resizable().frame(width: 50, height: 50)
            VStack {
                
                HStack {
                    Text(directions.destination.name)
                    Spacer()
                }
            }.padding()
            Button(action: {
                navigationRoute.removeDirections(destination: directions.destination)
            }) {
                Image(systemName: "xmark").foregroundColor(.black)
            }
        }.padding().background(Color.theme.background2).cornerRadius(10)
    }
}

//struct DirectionsList_Previews: PreviewProvider {
//    static var previews: some View {
//        DirectionsList()
//    }
//}
