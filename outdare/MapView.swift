//
//  MapView.swift
//  outdare
//
//  Created by Sam Hämäläinen on 4.4.2022.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let icon: String
}

struct MapView: View {
    
    @StateObject private var viewModel = MapViewModel()
    
    let challengeLocations = [
        Location(name: "S-market", coordinate: CLLocationCoordinate2D(latitude: 60.22506138615499, longitude: 24.759728409055466), icon: "tongueTwister"),
        Location(name: "Nokia networks", coordinate: CLLocationCoordinate2D(latitude: 60.224810974873215, longitude: 24.75657413146672), icon: "quiz"),
        Location(name: "Nokia building", coordinate: CLLocationCoordinate2D(latitude: 60.2218728358288, longitude: 24.755961678670257), icon: "singing"),
    ]
    
    var body: some View {
        Map(coordinateRegion: $viewModel.mapRegion, showsUserLocation: true, annotationItems: challengeLocations) { location in
            MapAnnotation(coordinate: location.coordinate) {
                Image(location.icon)
            }
            
        }
        .ignoresSafeArea()
        .onAppear {
            viewModel.checkIfLocationServicesIsEnabled()
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
