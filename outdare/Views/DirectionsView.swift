//
//  DirectionsView.swift
//  outdare
//
//  Created by Tatu Ihaksi on 16.4.2022.
//

import SwiftUI
/// A view where user can see the route's directions, edit the route and remove directions
struct DirectionsView: View {
    @ObservedObject var navigationRoute: NavigationRoute
    @Binding var isOpen: Bool
    
    var body: some View {
        GeometryReader { metrics in
            VStack {
                exitButton
                HStack {
                    removeAllButton
                    sortByDistanceButton
                }
                VStack(alignment: .leading) {
                    Text("Your route").font(Font.customFont.extraLargeText).padding(.bottom)
                    routeInfo
                    if navigationRoute.directionsArray.isEmpty {
                        emptyRouteMessage
                    } else {
                        DirectionsList(navigationRoute: navigationRoute)
                    }
                }.padding().frame(height: metrics.size.height * 0.8, alignment: .top)
            }.background(.white).frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
    /// Returns time given in seconds in hours and minutes
    static func formattedTime(of seconds: Double) -> String {
        let minutes = seconds / 60
        if minutes > 60 {
            let min = Int(minutes) % 60
            let hour = (Int(minutes) - min) / 60
            return String("\(hour) h \(min) min")
        }
        return String(format: "%.0f min", minutes)
    }
    /// Returns distance given in meters as kilometers or meters
    static func formattedDistance(of meters: Double) -> String {
        if meters >= 1000 {
            let km = meters / 1000
            return String(format: "%.2f km", km)
        }
        return String(format: "%.0f meters", meters)
    }
    /// Button for exiting the directions view
    private var exitButton: some View {
        Button(action: { isOpen = false }) {
            Text("Exit")
                .font(Font.customFont.btnText)
                .fontWeight(.semibold)
                .frame(width: 200)
                .padding(.vertical, 10)
                .background(Color("Button"))
                .foregroundColor(.white)
                .cornerRadius(70)
        }.padding()
    }
    /// Button for removing all the directions
    private var removeAllButton: some View {
        Button(action: {
            navigationRoute.removeDirections()
        }) {
            Text("Remove all")
                .font(Font.customFont.btnText)
                .fontWeight(.semibold)
                .padding(10)
                .background(Color.theme.rankingDown)
                .foregroundColor(.white)
                .cornerRadius(70)
        }
    }
    /// Button for sorting the challenges by how close they are from the user
    private var sortByDistanceButton: some View {
        Button(action: {
            navigationRoute.sortDirectionsByDistance()
        }) {
            Text("Sort by distance")
                .font(Font.customFont.btnText)
                .fontWeight(.semibold)
                .padding(10)
                .background(Color("Button"))
                .foregroundColor(.white)
                .cornerRadius(70)
        }
    }
    /// Part of view which has the message if there are no directions to show
    private var emptyRouteMessage: some View {
        HStack {
            Spacer()
            VStack(alignment: .center) {
                Text("Your route is currently empty").bold().font(Font.customFont.normalText).padding(.bottom, 2)
                Text("Select a challenge from the map to add directions to the route")
                    .multilineTextAlignment(.center).font(Font.customFont.normalText)
            }
            Spacer()
        }
    }
    /// Part of view that shows the route's total distance and time
    private var routeInfo: some View {
        HStack {
            if !navigationRoute.directionsArray.isEmpty {
                Image(systemName: "clock")
                Text(DirectionsView.formattedTime(of: navigationRoute.totalTime)).font(Font.customFont.normalText)
                Image(systemName: "arrow.left.and.right")
                Text(DirectionsView.formattedDistance(of: navigationRoute.totalDistance)).font(Font.customFont.normalText)
            }
            Spacer()
        }
    }
        
}
struct DirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsView(navigationRoute: NavigationRoute(), isOpen: .constant(true))
    }
}
