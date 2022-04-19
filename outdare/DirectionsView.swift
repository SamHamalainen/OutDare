//
//  DirectionsView.swift
//  outdare
//
//  Created by Tatu Ihaksi on 16.4.2022.
//

import SwiftUI

struct DirectionsView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var navigationRoute: NavigationRoute
    
    private func formattedTime(time: Double) -> String {
        let formattedTime = time / 60
        if formattedTime > 60 {
            let min = Int(formattedTime) % 60
            let hour = (Int(formattedTime) - min) / 60
            return String("\(hour) h \(min) min")
        }
        return String(format: "%.0f min", formattedTime)
    }
    private func formatDistance(meters: Double) -> String {
        if meters >= 1000 {
            let km = meters / 1000
            return String(format: "%.2f km", km)
        }
        return String(format: "%.0f meters", meters)
    }

    var body: some View {
        VStack {
            //padding()
            Button(action: {dismiss()}) {
                Text("Exit")
                    .font(Font.customFont.btnText)
                    .fontWeight(.semibold)
                    .frame(width: 200)
                    .padding(.vertical, 10)
                    .background(Color("Button"))
                    .foregroundColor(.white)
                    .cornerRadius(70)
            }.padding()
            
            Button(action: {
                navigationRoute.removeDirections()
            }) {
                Text("Remove all")
                    
            }
            VStack(alignment: .leading) {
                Text("Your route").font(Font.title).padding(.bottom)
                HStack {
                    if !navigationRoute.directionsArray.isEmpty {
                        Image(systemName: "clock")
                        Text(formattedTime(time:navigationRoute.totalTime))
                        Image(systemName: "arrow.left.and.right")
                        Text(formatDistance(meters:navigationRoute.totalDistance))}
                    Spacer()
                }

                Image("chuckTheChick").resizable().scaledToFit().frame(width: 50, height: 70)
                ForEach(navigationRoute.directionsArray) {directions in
                    HStack {
                        Image(systemName: "arrow.down").resizable().scaledToFit().frame(width: 50, height: 50)
                        HStack {
                            Image(systemName: "clock")
                            Text(formattedTime(time: directions.mkRoute.expectedTravelTime))
                            Image(systemName: "arrow.left.and.right")
                            Text(formatDistance(meters: directions.mkRoute.distance))
                        }.padding()
                        Spacer()
                    }
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
                            Image(systemName: "xmark")
                        }
                    }
                }
            }.padding()
            Spacer()
        }
    }
}
/*struct DirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsView()
    }
}*/
