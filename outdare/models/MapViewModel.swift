//
//  MapViewModel.swift
//  outdare
//
//  Created by Sam Hämäläinen on 4.4.2022.
//  Description: For handling MapView related functions.

import MapKit
import SwiftUI
import Speech

// Default values for map coordinate and span
enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 60.22418227428884, longitude: 24.758741356204567)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
}

// For checking if coordinates are equal and calculating distance between two CLLocationCoordinate2D points.
extension CLLocationCoordinate2D: Equatable {
    static public func ==(lhs: Self, rhs: Self) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        MKMapPoint(self).distance(to: MKMapPoint(to))
    }
}


// MapViewModel is for handling all MapView related functions.
final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    // Daos
    @Published var dao: ChallengeDAO?
    @Published var userDao: UserDAO?
    
    // User related
    @Published var userLocation: CLLocationCoordinate2D?
    var locationOld: CLLocation? = nil
    @Published var userSelectedTracking = false
    @Published var distanceTravelled: Double = 0
    
    // Map related
    @Published var map = MKMapView()
    @Published var region = MKCoordinateRegion()
    @Published var circle: MKCircle?
    @Published var annotationsArray: [MKPointAnnotation]?
    @Published var mapRegion = MKCoordinateRegion(
        center: MapDetails.startingLocation,
        span: MapDetails.defaultSpan
    )
    
    // Challenge related
    @Published var challengeInfoOpen: Bool = false
    @Published var selection: Challenge?
    @Published var selectedAnnotation: MKAnnotation?
    
    // Setting up daos when MapViewModel is initialized
    func setup(_ userDao: UserDAO, _ challengeDao: ChallengeDAO){
        self.userDao = userDao
        self.dao = challengeDao
    }
    
    // MARK: LocationManager
    private var locationManager: CLLocationManager?
    
    // Get users location from CLLocationManager for quiz generators map
    func getUserLocation() {
        locationManager = CLLocationManager()
        if let location = locationManager?.location {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        }
    }
    
    // Check if location services is enabled in settings to show and set the appropriate accuracy and tracking settings
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
                if let userLoc = self.userLocation {
                    self.mapRegion.center = userLoc
                }
            }
        } else {
            print("Please turn on location services from the phone settings")
        }
    }
    
    // MARK: Permissions
    
    // Check permissions for speech regognition
    func checkSRPermission() {
        if SFSpeechRecognizer.authorizationStatus() != .authorized {
            SFSpeechRecognizer.requestAuthorization({ (status) in
                switch status {
                case .notDetermined:
                    print("SR permission not determined")
                case .denied:
                    print("SR permission denied")
                case .restricted:
                    print("SR permission restricted")
                case .authorized:
                    return
                @unknown default:
                    print("SR permision status unknown")
                }
            })
        }
    }
    
    // Check permissions for location services
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
    
    // If user changes the permissions for location services on their phone, this function will automatically run
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    
    // MARK: User location and annotations
    
    // Function that is called when user location changes and then updates the users location variable.
    // After it recieves latest location it will update the circle radius and annotation coloring.
    // Distance travelled is also calculated based on last location and latest location.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationLast = locations.last else { return }
        for location in locations {
            calculateDistanceTravelled(location)
            showCircle(coordinate: location.coordinate, radius: 150, mapView: self.map)
            updateAnnotations(coordinate: location.coordinate, mapView: self.map)
        }
        if let userDao = userDao {
            if distanceTravelled >= 1000 {
                userDao.updateWalkingScore()
                distanceTravelled = 0
            }
        }
        userLocation = locationLast.coordinate
    }
    
    // Calculating distance from previous location to new location
    func calculateDistanceTravelled(_ current: CLLocation) {
        guard locationOld != nil else {
            locationOld = current
            return
        }
        distanceTravelled += locationOld!.distance(from: current)
        locationOld = current
    }
    
    // Displaying circle radius around the user
    func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, mapView: MKMapView) {
        if let circle = self.circle {
            map.removeOverlay(circle)
        }
        self.circle = MKCircle(center: coordinate, radius: radius)
        mapView.addOverlay(circle!)
    }
    
    // Check if annotations are in range and render annotations according to the result
    func updateAnnotations(coordinate: CLLocationCoordinate2D, mapView: MKMapView) {
        let oldAnnotations = self.annotationsArray ?? []
        self.annotationsArray = dao!.updateAnnotationsBasedOnDistance(userLoc: coordinate, annotationsArray: dao!.annotations)
        if let annotationsArray1 = self.annotationsArray {
            mapView.addAnnotations(annotationsArray1)
            map.removeAnnotations(oldAnnotations)
        }
    }
}
