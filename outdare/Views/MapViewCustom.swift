//
//  MapViewCustom.swift
//  outdare
//
//  Created by Sam Hämäläinen on 14.4.2022.
//  Description: MapViewCustom is a custom made map to show custom user icon and custom annotations

import SwiftUI
import MapKit

// MARK: MapViewCustom

struct MapViewCustom: UIViewRepresentable {
    @ObservedObject var viewModel: MapViewModel
    @ObservedObject var dao: ChallengeDAO
    @Binding public var challengeInfoOpened: Bool
    @ObservedObject var navigationRoute: NavigationRoute
    let annotations: [MKAnnotation]
    
    // Create a coordinator for mapView
    func makeCoordinator() -> Coordinator {
        Coordinator(self, vm: viewModel, dao: dao, nr: navigationRoute)
    }
    
    // When MapViewCustom is initialized this function will create the initial map UI
    func makeUIView(context: Context) -> MKMapView {
        viewModel.checkIfLocationServicesIsEnabled()
        viewModel.checkSRPermission()
        let mapView = viewModel.map
        navigationRoute.mapView = mapView
        if let userLocation = viewModel.userLocation {
            navigationRoute.userLocation = userLocation
        }
        
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
//        mapView.showsCompass = true
//        mapView.mapType = .mutedStandard
        
        mapView.setRegion(viewModel.mapRegion, animated: true)
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    // Update UI when map is moved, changed or otherwise needed to be modified
    func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<MapViewCustom>) {
        if viewModel.userSelectedTracking {
            mapView.userTrackingMode = .follow
        } else {
            mapView.userTrackingMode = .none
        }
        // Deselect selection
        if viewModel.selectedAnnotation != nil && viewModel.challengeInfoOpen == false {
            mapView.deselectAnnotation(viewModel.selectedAnnotation, animated: false)
        }
    }
}

// MARK: MapViewCustom Coordinator

class Coordinator: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate{
    @ObservedObject var viewModel: MapViewModel
    @ObservedObject var dao: ChallengeDAO
    @ObservedObject var navigationRoute: NavigationRoute
    @Published var selection: Challenge?
    var parent: MapViewCustom
    
    init(_ parent: MapViewCustom, vm: MapViewModel, dao: ChallengeDAO, nr: NavigationRoute){
        self.parent = parent
        self.viewModel = vm
        self.dao = dao
        self.navigationRoute = nr
    }
    
    // Function that creates renderers for the MKCircle and MKPolyline and displays them on the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.fillColor = .orange
            circleRenderer.alpha = 0.3
            return circleRenderer
        }
        if let dir = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(overlay: dir)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    // Function that tells the map how annotations should look like
    // Chuck the Chick as user location pin
    // Challenge annotation is displayed as the given icon in annotation.subtitle
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let pin = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.image = UIImage(named: "chuckTheChick")
            pin.frame.size = CGSize(width: 30, height: 60)
            return pin
        } else if annotation is MKPointAnnotation {
            let annotation2 = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotation2.image = UIImage(named: annotation.subtitle!!)
            annotation2.frame.size = CGSize(width: 30, height: 30)
            return annotation2
        }
        return nil
    }
    
    // When the user taps on an annotation, this function will tell the viewModel which one was selected
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationTitle = view.annotation?.title {
            viewModel.challengeInfoOpen = true
            selection = dao.challenges.first(where:{ $0.name == annotationTitle && $0.coordinates == view.annotation!.coordinate})
            viewModel.selection = self.selection
            viewModel.selectedAnnotation = view.annotation
            mapView.setRegion(MKCoordinateRegion(center: view.annotation!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
            
        }
    }
    
    // When users location changes on the map, this function is called to update the navigation route
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        navigationRoute.updateDirections(userLocation: userLocation.coordinate)
    }
}
