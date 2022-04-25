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
    var polyline: MKOverlay = MKPolyline()
}
enum DirectionsOption: Equatable {
    case makeFirst
    case makeLast
    case update
    case toIndex(Int)
}

final class NavigationRoute: ObservableObject {
    var mapView = MKMapView()
    @Published var directionsArray: [Directions] = []
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var totalTime: Double = 0.0
    @Published var totalDistance: Double = 0.0
    private var userPolylines: [MKOverlay] = []
    private var ignoreUserMoving = false
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
    private func removePolylines2() {
        let polylines = directionsArray.map { $0.polyline }
        mapView.removeOverlays(polylines)
    }
    private func addPolylines() {
//         removePolylines()
        let polylines = directionsArray.map { $0.polyline }
//        let i = polylines.firstIndex(where: { $0.title == activeDirections?.polyline.title })
//        if let i = polylines.firstIndex(where: { $0.title == activeDirections?.polyline.title }) {
//            polylines.remove(at: i)
//            mapView.addOverlays(polylines)
//        }
//        mapView.removeOverlays(polylines)
        let a = Array(polylines.dropFirst())
//        print("//addPlylines count \(a.count)")
//        print("//addPlylines count 2 \(polylines.count)")
//        mapView.removeOverlays(a)
        if userPolylines.isEmpty {
            mapView.addOverlays(polylines)
        } else
        {
            mapView.addOverlays(a)
        }
        //mapView.addOverlays(polylines)
    }
    func removeDirections(destination: Challenge? = nil) {
//        ignoreUserMoving = true
        if destination != nil {
            guard let i = directionsArray.firstIndex(where: {$0.destination == destination}) else { return }
            directionsArray.remove(at: i)
            reCreateExistingDirections()
        }
        else {
            activeDirections = nil
            removePolylines()
            userPolylines.removeAll()
            directionsArray.removeAll()
        }
        ignoreUserMoving = false
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
    func addDirections(directions: Directions, option: DirectionsOption) {
        if option != .update {ignoreUserMoving = true
            removePolylines()
        }
//        print("//adddircs \(directions.destination.name)")
        let request = createDirectionsRequest(directions: directions)
        let mkDirections = MKDirections(request: request)
        mkDirections.calculate { response, error in
            guard let route = response?.routes.first else { return }
            
//            self.mapView.addOverlay(route.polyline)
//            if option != .update /*&& option != .toIndex(0)*/ {
//                self.mapView.addOverlay(route.polyline)
//            }
            if self.directionsArray.isEmpty || option == .update {
                if self.userPolylines.count < 2 {
                    self.userPolylines.append(route.polyline)
                    self.mapView.addOverlay(route.polyline)
                }
            }
            if option != .update {
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),animated: true)
            }
            // Make directions instance and add it to the array
            let directions = Directions(source: directions.source, destination: directions.destination, mkRoute: route, polyline: route.polyline)

            self.updateDirectionsArray(directions: directions, option: option)
            self.updateDistanceAndTime()
            self.ignoreUserMoving = false
            
            if option != .update {
//                self.removePolylines2()
                self.removePolylines()
                self.addPolylines()}
        }
//        if option != .update {
//            removePolylines2()
//            addPolylines()}
        ignoreUserMoving = false
//        if option == .makeFirst
        //{print("//after add count\(directionsArray.count)")}
    }
    private func updateDirectionsArray(directions: Directions, option: DirectionsOption) {
        switch (option) {
        case .makeFirst:
            activeDirections = directions
//            print("//update drarray \(directions.destination.name)")
            directionsArray.insert(directions, at: 0)
            //print("//update dir count \(directionsArray.count)")
            if directionsArray.count > 1 {
                reCreateExistingDirections()
            }
        case .update:
            if !directionsArray.isEmpty {
                directionsArray[0] = directions
            } else {
                directionsArray.append(directions)
            }
        case .makeLast:
            directionsArray.append(directions)
        case .toIndex(let i):
            // directionsArray.insert(directions, at: i)
            if i == 0 {
//                mapView.removeOverlay(directions.polyline)
            }
            directionsArray[i] = directions
        }
    
    }
    private func reCreateExistingDirections() {
//        print("//dir count 2 \(directionsArray.count)")
//        print("//re-create \(directionsArray[0].destination.name)")
//        removePolylines()
        let count = directionsArray.count
        for (index, item) in directionsArray.enumerated() {
        
            if index == 0 {
                if let source = userLocation {
                    
//                    print("//i 0 \(item.destination.name)")
                    let directions = Directions(source: source, destination: item.destination)
                    //addDirections(directions: directions, option: .makeLast)
                    activeDirections = directions
                    addDirections(directions: directions, option: .toIndex(index))
                }
            } else {
                let source = directionsArray[index-1].destination.coordinates
//                print("//from \(directionsArray[index-1].destination.name) to \(item.destination.name)")
                let directions = Directions(source: source, destination: item.destination)
                // addDirections(directions: directions, option: .makeLast)
                addDirections(directions: directions, option: .toIndex(index))
            }
        }
//        removePolylines2()
//        addPolylines()
//        print("//re-create array count\(directionsArray.count) count \(count)")
//        print("//re-create array first\(directionsArray[0].destination.name) count \(count)")
        // directionsArray = Array(directionsArray.dropFirst(count))
        //print("//re-create after \(directionsArray[0].destination.name)")
    }
    /// Updates directions by replacing the first directions object by new one
    func updateDirections(userLocation: CLLocationCoordinate2D) {
        // print("//before upload count \(directionsArray.count)")
        self.userLocation = userLocation
//        guard let firstDirections = directionsArray[0] else { return }
        if directionsArray.isEmpty { return }
 //       if activeDirections?.destination.id != directionsArray.first?.destination.id { return }
//        if ignoreUserMoving { return }
        
//        if !ignoreUserMoving{
        guard let firstDirections = activeDirections else { return }//directionsArray[0]
            let directions = Directions(source: userLocation, destination: firstDirections.destination)
            addDirections(directions: directions, option: .update)
            
//        }
        
        let count = userPolylines.count

        mapView.removeOverlay(firstDirections.polyline)
//        mapView.removeOverlay(directionsArray[0].polyline)
        //if count > 1 {
        if userPolylines.count > 1 {
//            mapView.removeOverlay(userPolylines.first!)
//            userPolylines.removeFirst()
            mapView.removeOverlays(Array(userPolylines.dropLast()))
            userPolylines = Array(userPolylines.dropFirst(count-1))
        }
    }
    /// Sorts directions by how close the directions' destination is from user's location
    func sortDirectionsByDistance() {
        ignoreUserMoving = true
        if let userLocation = userLocation {
            directionsArray.sort(by: { $0.destination.coordinates.distance(to: userLocation) < $1.destination.coordinates.distance(to: userLocation) })
            activeDirections = directionsArray[0]
            if activeDirections?.id == directionsArray[0].id {
                reCreateExistingDirections()
                addPolylines()
            }
        }
        ignoreUserMoving = false
    }
}
