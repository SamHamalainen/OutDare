//
//  MapViewModel.swift
//  outdare
//
//  Created by Sam Hämäläinen on 4.4.2022.
//

import MapKit

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 60.22418227428884, longitude: 24.758741356204567)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
}

final class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var mapRegion = MKCoordinateRegion(
        center: MapDetails.startingLocation,
        span: MapDetails.defaultSpan
    )
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    
    private var locationManager: CLLocationManager?
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.startUpdatingLocation()
            locationManager!.pausesLocationUpdatesAutomatically = true
        } else {
            print("Please turn on location services from the phone settings")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLatitude = location.coordinate.latitude
        userLongitude = location.coordinate.longitude
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
            mapRegion = MKCoordinateRegion(center: locationManager.location!.coordinate,
                                           span: MapDetails.defaultSpan)
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
