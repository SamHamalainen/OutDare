//
//  MapViewModel.swift
//  outdare
//
//  Created by Sam Hämäläinen on 4.4.2022.
//
import MapKit
import SwiftUI

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 60.22418227428884, longitude: 24.758741356204567)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
    
}

extension CLLocationCoordinate2D: Equatable {
    static public func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
            MKMapPoint(self).distance(to: MKMapPoint(to))
        }
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var mapRegion = MKCoordinateRegion(
        center: MapDetails.startingLocation,
        span: MapDetails.defaultSpan
    )
    @Published var dao = ChallengeDAO()
    @Published var userDao: UserDAO?
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var challengeInfoOpen: Bool = false
    @Published var selection: Challenge?
    @Published var userSelectedTracking = false
    @Published var distanceTravelled: Double = 0
    @Published var circle: MKCircle?
    @Published var map = MKMapView()
    var locationOld: CLLocation? = nil
    
    func setup(_ userDao: UserDAO){
        self.userDao = userDao
    }
    
    private var locationManager: CLLocationManager?
    
//    func getUserLocation() {
//        locationManager = CLLocationManager()
//        userLocation = locationManager?.location?.coordinate ?? CLLocationCoordinate2D(latitude: 61.9241, longitude: 25.75482)
//    }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            if let locManager = locationManager {
                self.userLocation = locManager.location?.coordinate
                locManager.delegate = self
                locManager.desiredAccuracy = kCLLocationAccuracyBest
                locManager.startUpdatingLocation()
                locManager.pausesLocationUpdatesAutomatically = true
                locManager.activityType = .fitness
//              locManager.distanceFilter = 10.0
            }
        } else {
            print("Please turn on location services from the phone settings")
        }
    }
    
    func calculateDistanceTravelled(_ current: CLLocation) {
        guard locationOld != nil else {
            locationOld = current
            return
        }
        distanceTravelled += locationOld!.distance(from: current)
        locationOld = current
    }
    
    func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, mapView: MKMapView) {
        if let circle = self.circle {
            map.removeOverlay(circle)
        }
        self.circle = MKCircle(center: coordinate, radius: radius)
        mapView.addOverlay(circle!)
       }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationLast = locations.last else { return }
        for location in locations {
            calculateDistanceTravelled(location)
            showCircle(coordinate: location.coordinate, radius: 150, mapView: self.map)
        }
        if let userDao = userDao {
            if distanceTravelled >= 900 {
                userDao.getLoggedInUserScore()
            }
            if distanceTravelled >= 1000 {
                if let userScore = userDao.loggedUserScore {
                    userDao.updateUsersScore(newScore: userScore + 5)
                    userDao.loggedUserScore = userScore + 5
                    distanceTravelled = 0
                }
            }
        }
        
        userLocation = locationLast.coordinate
    }
    
    private func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted")
        case .denied:
            print("You have denied this app location permission. Go into settings to change it.")
        case .authorizedAlways, .authorizedWhenInUse:
            if let userLoc = locationManager.location {
                mapRegion = MKCoordinateRegion(center: userLoc.coordinate, span: MapDetails.defaultSpan)
            }
        @unknown default:
            break
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    func getAnnotationSize() -> CGSize {
        let max: CGFloat = 64, min: CGFloat = 35
        var sideLength = max
        let span = mapRegion.span.latitudeDelta
        let defaultSpan = MapDetails.defaultSpan.latitudeDelta
        let scale = sideLength * defaultSpan
        

        sideLength = scale / (span * 0.5)
        
        if sideLength > max {sideLength = max}
        if sideLength < min {sideLength = min}

        print("side \(sideLength) span \(span)")
        
        return CGSize(width: sideLength, height: sideLength)
    }
}
