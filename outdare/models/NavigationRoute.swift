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

/// ObservableObject for the route. Has an array of directions, when combined create one route. Route has total estimated time
/// in seconds and distance in meters. Directions can be added and removed from the route and also sorted by distance from user.
final class NavigationRoute: ObservableObject {
    var mapView = MKMapView()
    @Published var directionsArray: [Directions] = []
    @Published var totalTime: Double = 0.0
    @Published var totalDistance: Double = 0.0
    @Published var userLocation: CLLocationCoordinate2D? {
        didSet {
            // Remove directions if user is close to destination
            if !directionsArray.isEmpty && (directionsArray[0].destination.coordinates.distance(to: userLocation!)) <= 150 {
                removeDirections(destination: directionsArray[0].destination)
            }
        }
    }
    /// Polylines array which gets updated constantly when user is moving on the map
    private var activePolylines: [MKOverlay] = []
    /// Directions which changes constantly when user is moving
    private var activeDirections: Directions?
    
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
            if option == .updateFirst && activePolylines.count < 2 {
                activePolylines.append(route.polyline)
                mapView.addOverlay(route.polyline)
            }

            // Make a directions instance and add it to the array
            let directions = Directions(source: source, destination: destination, mkRoute: route)

            addToDirectionsArray(directions: directions, option: option)
            // Update distance and time once the directions are added
            updateTotalDistanceAndTime()

            if option == .makeLast || option == .makeFirst {
                // Animation when directions are made to fit thwe whole polyline on the screen
                mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100),animated: true)
            }
        }
    }
    /// Removes directions from the directions array. If called with no parameters, all directions will be removed.
    /// - Parameters:
    ///     - destination: Challenge object of which directions to will be removed
    func removeDirections(destination: Challenge? = nil) {
        if destination != nil {
            // Find directions that has the given destination
            if let i = directionsArray.firstIndex(where: {$0.destination == destination}) {
                mapView.removeOverlay(directionsArray[i].mkRoute.polyline)
                directionsArray.remove(at: i)
                reCreateExistingDirections()
            }
        } else {
            // Remove all polylines and directions
            activeDirections = nil
            removePolylines()
            activePolylines.removeAll()
            directionsArray.removeAll()
        }
    }
    /// Sorts directions by how close the directions' destination is from the user's location
    func sortDirectionsByDistance() {
        if let userLocation = userLocation {
            directionsArray.sort(by: { $0.destination.coordinates.distance(to: userLocation) < $1.destination.coordinates.distance(to: userLocation) })
                reCreateExistingDirections()
        }
    }
    /// Updates routes total distance and time by getting their sums from directionsArray
    private func updateTotalDistanceAndTime() {
        totalTime = directionsArray.reduce(0) { $0 + $1.mkRoute.expectedTravelTime }
        totalDistance = directionsArray.reduce(0) { $0 + $1.mkRoute.distance }
    }
    /// Removes all polylines from the mapView's overlays
    private func removePolylines() {
        let polylines = mapView.overlays.filter({ $0 is MKPolyline })
        mapView.removeOverlays(polylines)
    }

    /// Creates and returns directions request for given source and destination
    private func createDirectionsRequest(from source: CLLocationCoordinate2D, to destination: Challenge) -> MKDirections.Request {
        let request = MKDirections.Request()
        let source = MKPlacemark(coordinate: source)
        let destination = MKPlacemark(coordinate: destination.coordinates)
        
        request.source = MKMapItem(placemark: source)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .walking
        return request
    }

    /// Adds directions to the array debending what option is selected
    private func addToDirectionsArray(directions: Directions, option: DirectionsOption) {
        switch (option) {
        case .makeFirst:
            activeDirections = directions // Set active directions to first
            directionsArray.insert(directions, at: 0)
            if directionsArray.count > 1 {
                reCreateExistingDirections()
            } else {
                mapView.addOverlay(directions.mkRoute.polyline)
            }
        case .updateFirst:
            if directionsArray.isEmpty {
                directionsArray.append(directions)
            } else {
                directionsArray[0] = directions
            }
        case .makeLast:
            directionsArray.append(directions)
            mapView.addOverlay(directions.mkRoute.polyline) // Add polyline to map
        case .toIndex(let i):
            // Remove old polyline from the map
            mapView.removeOverlay(directionsArray[i].mkRoute.polyline)
            directionsArray[i] = directions
            if activePolylines.isEmpty || i != 0 {
                mapView.addOverlay(directionsArray[i].mkRoute.polyline)
            }
        }
    
    }
    /// Goes through the whole directions array and re-creates them, so the whole route updates
    private func reCreateExistingDirections() {
        for (index, item) in directionsArray.enumerated() {
            if index == 0 {
                if let source = userLocation {
                    activeDirections = item // Make first active
                    addDirections(from: source, to: item.destination, option: .toIndex(index))
                }
            } else {
                // Source is last directions destination
                let source = directionsArray[index-1].destination.coordinates
                addDirections(from: source, to: item.destination, option: .toIndex(index))
            }
        }
    }
    /// Updates directions by replacing the first directions object by new one
    func updateDirections(userLocation: CLLocationCoordinate2D) {
        self.userLocation = userLocation // Update user location
        if directionsArray.isEmpty { return }
        guard let activeDirections = activeDirections else { return }
        addDirections(from: userLocation, to: activeDirections.destination, option: .updateFirst)
                    
        mapView.removeOverlay(activeDirections.mkRoute.polyline)
        
        let count = activePolylines.count
        // Remove old polylines coming from the user, when there is a new one
        if activePolylines.count > 1 {
            mapView.removeOverlays(Array(activePolylines.dropLast()))
            activePolylines = Array(activePolylines.dropFirst(count-1))
        }
    }
}
