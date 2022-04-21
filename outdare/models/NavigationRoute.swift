//
//  NavigationRoute.swift
//  outdare
//
//  Created by Tatu Ihaksi on 15.4.2022.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

struct Directions: Identifiable {
    let id = UUID()
    let source: CLLocationCoordinate2D
    let destination: Challenge
    var mkRoute: MKRoute = MKRoute()
    var polyline: MKPolyline = MKPolyline()
}

final class NavigationRoute: ObservableObject {
    var mapView = MKMapView()
    @Published var directionsArray: [Directions] = []
    var userLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @Published var totalTime: Double = 0.0
    @Published var totalDistance: Double = 0.0
    
    func removeDirections(destination: Challenge? = nil) {
        let polylines = mapView.overlays.filter({ $0 is MKPolyline })
        mapView.removeOverlays(polylines)
        totalDistance = 0.0
        totalTime = 0.0
        if destination != nil {
            let i = directionsArray.firstIndex(where: {$0.destination == destination})!
            directionsArray.remove(at: i)
            reCreateExistingDirections()
        }
        else {
            directionsArray.removeAll()
        }
    }
    func addDirections(directions: Directions, keepPrevious: Bool) {
        if !keepPrevious {
            removeDirections()
        }
        let request = MKDirections.Request()
        let source = MKPlacemark(coordinate: directions.source)
        let destination = MKPlacemark(coordinate: directions.destination.coordinates)
        
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        
        var mkRoute = MKRoute()
        var polyline = MKPolyline()
        let mkDirections = MKDirections(request: request)
        mkDirections.calculate { response, error in
            guard let route = response?.routes.first else { return }
            mkRoute = route
            polyline = route.polyline
            self.totalTime += route.expectedTravelTime
            self.totalDistance += route.distance
            self.mapView.addAnnotations([source,destination])
            self.mapView.addOverlay(route.polyline)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),animated: true)
            // Make directions instance and add it to the array
            let directions = Directions(source: directions.source, destination: directions.destination, mkRoute: mkRoute, polyline: polyline)
            self.directionsArray.append(directions)
        }
    }
    private func reCreateExistingDirections() {
        let count = directionsArray.count
        for (index, item) in directionsArray.enumerated() {
            if index == 0 {
                let directions = Directions(source: userLocation, destination: item.destination)
                addDirections(directions: directions, keepPrevious: true)
            } else {
                let source = directionsArray[index-1].destination.coordinates
                let directions = Directions(source: source, destination: item.destination)
                addDirections(directions: directions, keepPrevious: true)
            }
        }
        directionsArray = Array(directionsArray.dropFirst(count))
    }
}
