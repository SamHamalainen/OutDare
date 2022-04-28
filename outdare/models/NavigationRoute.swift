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

/// The object for the route made of many directions. 
final class NavigationRoute: ObservableObject {
    var mapView = MKMapView()
    @Published var directionsArray: [Directions] = []
    @Published var userLocation: CLLocationCoordinate2D? {
        didSet {
            if !directionsArray.isEmpty && (directionsArray[0].destination.coordinates.distance(to: userLocation!)) <= 150 {
                removeDirections(destination: directionsArray[0].destination)
            }
        }
    }
    @Published var totalTime: Double = 0.0
    @Published var totalDistance: Double = 0.0
    /// Polylines array which gets updated constantly when user is moving on the map
    private var activePolylines: [MKOverlay] = []
    /// Directions which changes constantly when user is moving
    private var activeDirections: Directions?

    /// Updates routes total distance and time by getting their sums from directionsArray
    private func updateDistanceAndTime() {
        totalTime = directionsArray.reduce(0) { $0 + $1.mkRoute.expectedTravelTime }
        totalDistance = directionsArray.reduce(0) { $0 + $1.mkRoute.distance }
    }
    /// Removes all polylines from the mapView's overlays
    private func removePolylines() {
        let polylines = mapView.overlays.filter({ $0 is MKPolyline })
        mapView.removeOverlays(polylines)
    }
    
    private func addPolylines() {
        let polylines = directionsArray.map { $0.mkRoute.polyline }
        let staticPolylines = Array(polylines.dropFirst())
        if activePolylines.isEmpty {
            mapView.addOverlays(polylines)
        } else {
            mapView.addOverlays(staticPolylines)
        }
    }
    /// Removes directions from the directions array. If called with no parameters, all directions will be removed.
    /// - Parameters:
    ///     - destination: Challenge object of which directions to will be removed
    func removeDirections(destination: Challenge? = nil) {
        if destination != nil {
            if let i = directionsArray.firstIndex(where: {$0.destination == destination}) {
                directionsArray.remove(at: i)
                reCreateExistingDirections()
            }
        } else {
            activeDirections = nil
            removePolylines()
            activePolylines.removeAll()
            directionsArray.removeAll()
        }
    }
    private func createDirectionsRequest(from source: CLLocationCoordinate2D, to destination: Challenge) -> MKDirections.Request {
        let request = MKDirections.Request()
        let source = MKPlacemark(coordinate: source)
        let destination = MKPlacemark(coordinate: destination.coordinates)
        
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        return request
    }
    /// Add directions to route
    /// - Parameters:
    ///     - source: starting location for directions
    ///     - destination: challenge where directions are wanted to
    ///     - option: how directions are added to route
    func addDirections(from source: CLLocationCoordinate2D, to destination: Challenge, option: DirectionsOption) {
        let request = createDirectionsRequest(from: source, to: destination)
        let mkDirections = MKDirections(request: request)
        mkDirections.calculate { [self] response, error in
            guard let route = response?.routes.first else { return }
            if option == .update && activePolylines.count < 2 {
                activePolylines.append(route.polyline)
                mapView.addOverlay(route.polyline)
            }

            // Make a directions instance and add it to the array
            let directions = Directions(source: source, destination: destination, mkRoute: route)

            addToDirectionsArray(directions: directions, option: option)
            updateDistanceAndTime()

            if option != .update {
                // Animation when directions are made to fit thwe whole polyline on the screen
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),animated: true)
                removePolylines()
                addPolylines()
            }
        }
    }
    /// Adds directions to the array debending what option is selected
    private func addToDirectionsArray(directions: Directions, option: DirectionsOption) {
        switch (option) {
        case .makeFirst:
            activeDirections = directions
            directionsArray.insert(directions, at: 0)
            if directionsArray.count > 1 {
                reCreateExistingDirections()
            }
        case .update:
            if directionsArray.isEmpty {
                directionsArray.append(directions)
            } else {
                directionsArray[0] = directions
            }
        case .makeLast:
            directionsArray.append(directions)
        case .toIndex(let i):
            directionsArray[i] = directions
        }
    
    }
    /// Goes through the whole directions array and re-creates them, so the whole route updates
    private func reCreateExistingDirections() {
        for (index, item) in directionsArray.enumerated() {
            if index == 0 {
                if let source = userLocation {
                    activeDirections = item
                    addDirections(from: source, to: item.destination, option: .toIndex(index))
                }
            } else {
                let source = directionsArray[index-1].destination.coordinates
                addDirections(from: source, to: item.destination, option: .toIndex(index))
            }
        }
        removePolylines()
        addPolylines()
    }
    /// Updates directions by replacing the first directions object by new one
    func updateDirections(userLocation: CLLocationCoordinate2D) {
        self.userLocation = userLocation
        if directionsArray.isEmpty { return }
        guard let activeDirections = activeDirections else { return }
            addDirections(from: userLocation, to: activeDirections.destination, option: .update)
                    
        let count = activePolylines.count

        mapView.removeOverlay(activeDirections.mkRoute.polyline)

        if activePolylines.count > 1 {
            mapView.removeOverlays(Array(activePolylines.dropLast()))
            activePolylines = Array(activePolylines.dropFirst(count-1))
        }
    }
    /// Sorts directions by how close the directions' destination is from the user's location
    func sortDirectionsByDistance() {
        if let userLocation = userLocation {
            directionsArray.sort(by: { $0.destination.coordinates.distance(to: userLocation) < $1.destination.coordinates.distance(to: userLocation) })
                reCreateExistingDirections()
        }
    }
}
