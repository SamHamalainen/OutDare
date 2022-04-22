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
    @Published var userPolylines: [MKOverlay] = []
    
    /// Updates routes total distance and time
    private func updateDistanceAndTime() {
        totalTime = directionsArray.reduce(0) { $0 + $1.mkRoute.expectedTravelTime }
        totalDistance = directionsArray.reduce(0) { $0 + $1.mkRoute.distance }
    }
    func removeDirections(destination: Challenge? = nil) {
        let polylines = mapView.overlays.filter({ $0 is MKPolyline })
        mapView.removeOverlays(polylines)
        if destination != nil {
            guard let i = directionsArray.firstIndex(where: {$0.destination == destination}) else { return }
            directionsArray.remove(at: i)
            reCreateExistingDirections()
        }
        else {
            directionsArray.removeAll()
        }
    }
    private func createDirectionsRequest(directions: Directions) -> MKDirections.Request {
        let request = MKDirections.Request()
        let source = MKPlacemark(coordinate: directions.source)
        let destination = MKPlacemark(coordinate: directions.destination.coordinates)
        
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        return request
    }
    func addDirections(directions: Directions, keepPrevious: Bool, updateFirst: Bool = false) {
        if !keepPrevious {
            removeDirections()
        }
        let request = createDirectionsRequest(directions: directions)
        let mkDirections = MKDirections(request: request)
        mkDirections.calculate { response, error in
            guard let route = response?.routes.first else { return }
            self.mapView.addOverlay(route.polyline)
            if updateFirst || !keepPrevious {
                self.userPolylines.append(route.polyline)
            }
            if !updateFirst {
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),animated: true)
            }
            // Make directions instance and add it to the array
            let directions = Directions(source: directions.source, destination: directions.destination, mkRoute: route, polyline: route.polyline)

            self.updateDirectionsArray(directions: directions, firstElement: updateFirst)
            self.updateDistanceAndTime()
        }
    }
    private func updateDirectionsArray(directions: Directions, firstElement: Bool) {
        if firstElement && !directionsArray.isEmpty {
            directionsArray[0] = directions
        } else {
            directionsArray.append(directions)
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
    /// Updates directions by replacing the first directions object by new one
    func updateDirections(userLocation: CLLocationCoordinate2D) {
        guard let firstDirections = directionsArray.first else { return }
        let s = Directions(source: userLocation, destination: firstDirections.destination)
            addDirections(directions: s, keepPrevious: true, updateFirst: true)
            
        if userPolylines.count > 1 {
            mapView.removeOverlay(userPolylines.first!)
            userPolylines.removeFirst()
        }
    }
}
