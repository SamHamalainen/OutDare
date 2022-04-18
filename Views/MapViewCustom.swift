//
//  MapViewCustom.swift
//  outdare
//
//  Created by Sam Hämäläinen on 14.4.2022.
//

import SwiftUI
import MapKit

// MARK: MapViewCustom

struct MapViewCustom: UIViewRepresentable {
    @ObservedObject var viewModel: MapViewModel
    @ObservedObject var dao: ChallengeDAO
    @Binding public var challengeInfoOpened: Bool
    let annotations: [MKAnnotation]
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, vm: viewModel, dao: dao)
    }
    
    
    func makeUIView(context: Context) -> MKMapView {
        viewModel.checkIfLocationServicesIsEnabled()
        print("annotations: \(annotations)")
        let mapView = MKMapView()
        
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        mapView.mapType = .mutedStandard
        mapView.userTrackingMode = .none
        
        let overlay = MKCircle(center: viewModel.userLocation ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: 150)
        mapView.addOverlay(overlay)
        let span = viewModel.userLocation != nil
            ? MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.001)
            : MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
        
        mapView.setRegion(MKCoordinateRegion(center: viewModel.userLocation ?? CLLocationCoordinate2D(latitude: 61.9241, longitude: 25.75482), span: span), animated: true)
        mapView.addAnnotations(annotations)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<MapViewCustom>) {
        if viewModel.userSelectedTracking {
            mapView.userTrackingMode = .follow
            mapView.addAnnotations(annotations)
        } else {
            mapView.userTrackingMode = .none
        }
        if viewModel.challengeInfoOpen == false {
            for annotation in annotations {
                mapView.deselectAnnotation(annotation, animated: false)
            }
        }
        
    }
}

extension UIImage {
    var mono: UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIPhotoEffectMono") else { return nil }
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        if let output = currentFilter.outputImage,
            let cgImage = context.createCGImage(output, from: output.extent) {
            return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
        }
        return nil
    }
}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

// MARK: MapViewCustom Coordinator

class Coordinator: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate{
    @ObservedObject var viewModel: MapViewModel
    @ObservedObject var dao: ChallengeDAO
    @Published var selection: Challenge?
    var parent: MapViewCustom
    init(_ parent: MapViewCustom, vm: MapViewModel, dao: ChallengeDAO){
        self.parent = parent
        self.viewModel = vm
        self.dao = dao
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.fillColor = .orange
            circleRenderer.alpha = 0.5
            return circleRenderer
        }
        return MKOverlayRenderer()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let pin = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.image = UIImage(named: "chuckTheChick")
            pin.frame.size = CGSize(width: 30, height: 60)
            return pin
        } else if annotation is MKPointAnnotation {
            if viewModel.userLocation != nil {
                if annotation.coordinate.distance(to: viewModel.userLocation!) <= 150 {
                    let annotation2 = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
                    annotation2.image = UIImage(named: (annotation.subtitle!!))
                    annotation2.frame.size = CGSize(width: 30, height: 30)
                    return annotation2
                } else {
                    let annotation3 = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
                    annotation3.image = UIImage(named: (annotation.subtitle!!))?.mono
                    annotation3.frame.size = CGSize(width: 30, height: 30)
                    return annotation3
                }
            }
        }
        return nil
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationTitle = view.annotation?.title {
            viewModel.challengeInfoOpen = true
            selection = dao.challenges.first(where:{ $0.name == annotationTitle && $0.coordinates == view.annotation!.coordinate})
            viewModel.selection = self.selection
            if viewModel.selection != nil {
                print("selection \(viewModel.selection!)")
            }
            mapView.setRegion(MKCoordinateRegion(center: view.annotation!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
            
        }
    }
}
