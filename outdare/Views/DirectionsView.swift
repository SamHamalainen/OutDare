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
    
    private func formattedTime(of seconds: Double) -> String {
        let minutes = seconds / 60
        if minutes > 60 {
            let min = Int(minutes) % 60
            let hour = (Int(minutes) - min) / 60
            return String("\(hour) h \(min) min")
        }
        return String(format: "%.0f min", minutes)
    }
    private func formattedDistance(of meters: Double) -> String {
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
            Button(action: {
                navigationRoute.sortDirectionsByDistance()
            }) {
                Text("Sort by distance")
            }
            VStack(alignment: .leading) {
                Text("Your route").font(Font.title).padding(.bottom)
                HStack {
                    if !navigationRoute.directionsArray.isEmpty {
                        Image(systemName: "clock")
                        Text(formattedTime(of: navigationRoute.totalTime))
                        Image(systemName: "arrow.left.and.right")
                        Text(formattedDistance(of: navigationRoute.totalDistance))}
                    Spacer()
                }

                Image("chuckTheChick").resizable().scaledToFit().frame(width: 50, height: 70)
                ForEach(navigationRoute.directionsArray) {directions in
                    HStack {
                        VStack {
                            Image(systemName: "arrow.down").resizable().scaledToFit().frame(width: 30, height: 30)
                        }.frame(width: 50)
                        
                        HStack {
                            Image(systemName: "clock")
                            Text(formattedTime(of: directions.mkRoute.expectedTravelTime))
                            Image(systemName: "arrow.left.and.right")
                            Text(formattedDistance(of: directions.mkRoute.distance))
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
