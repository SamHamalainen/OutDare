//
//  MapViewModel.swift
//  outdare
//
//  Created by Sam Hämäläinen on 4.4.2022.
//
import MapKit
import SwiftUI
import Speech

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 60.22418227428884, longitude: 24.758741356204567)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    
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
    @Published var dao: ChallengeDAO?
    @Published var userDao: UserDAO?
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var challengeInfoOpen: Bool = false
    @Published var selection: Challenge?
    @Published var userSelectedTracking = false
    @Published var distanceTravelled: Double = 0
    @Published var circle: MKCircle?
    @Published var annotationsArray: [MKPointAnnotation]?
    @Published var map = MKMapView()
    @Published var region = MKCoordinateRegion()
    var locationOld: CLLocation? = nil
    @Published var count = 0
    
    func setup(_ userDao: UserDAO, _ challengeDao: ChallengeDAO){
        self.userDao = userDao
        self.dao = challengeDao
    }
    
    private var locationManager: CLLocationManager?
    
//    func getUserLocation() {
//        locationManager = CLLocationManager()
//        userLocation = locationManager?.location?.coordinate ?? CLLocationCoordinate2D(latitude: 61.9241, longitude: 25.75482)
//    }
    
    func getUserLocation() {
        locationManager = CLLocationManager()
        if let location = locationManager?.location {
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
        }
    }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            if let locManager = locationManager {
                self.userLocation = locManager.location?.coordinate
                self.mapRegion = MKCoordinateRegion(center: locManager.location!.coordinate, span: MapDetails.defaultSpan)
                locManager.delegate = self
                locManager.desiredAccuracy = kCLLocationAccuracyBest
                locManager.startUpdatingLocation()
                locManager.pausesLocationUpdatesAutomatically = true
                locManager.activityType = .fitness
            }
        } else {
            print("Please turn on location services from the phone settings")
        }
    }
    
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
    
    func updateAnnotations(coordinate: CLLocationCoordinate2D, mapView: MKMapView) {
        let oldAnnotations = self.annotationsArray ?? []
        self.annotationsArray = dao!.updateAnnotationsBasedOnDistance(userLoc: coordinate, annotationsArray: dao!.annotations)
        if let annotationsArray1 = self.annotationsArray {
            mapView.addAnnotations(annotationsArray1)
            map.removeAnnotations(oldAnnotations)
        }
//            else {
//            self.annotationsArray = dao!.updateAnnotationsBasedOnDistance(userLoc: coordinate, annotationsArray: dao!.annotations)
//            mapView.addAnnotations(annotationsArray!)
//        }
    }
    
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
