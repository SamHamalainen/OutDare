//
//  MapView.swift
//  outdare
//
//  Created by Sam Hämäläinen on 4.4.2022.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @ObservedObject private var viewModel = MapViewModel()
//    @State var challengeInfoOpened = false
    @State var challengePassed: Challenge?
    @ObservedObject var dao = ChallengeDAO()
    
    
    var body: some View {
        ZStack(alignment: .top)  {
//            Map(coordinateRegion: $viewModel.mapRegion,showsUserLocation: true, annotationItems: dao.challenges) { challenge in
//                MapAnnotation(coordinate: challenge.coordinates) {
//                    Image(challenge.icon)
//                        .onTapGesture {
//                            print("clicked on \(challenge.name)")
//                            challengePassed = challenge
//                            challengeInfoOpened = true
//                        }
//                        .contrast(0.3)
//                }
//            }
//            .ignoresSafeArea(edges: .bottom)
//            .onAppear {
//                viewModel.checkIfLocationServicesIsEnabled()
//                dao.getChallenges()
//            }
            if !dao.annotations.isEmpty && viewModel.userLocation != nil {
                MapViewCustom(viewModel: viewModel, dao: dao, challengeInfoOpened: $viewModel.challengeInfoOpen, annotations: dao.annotations)
                    .ignoresSafeArea(edges: .bottom)
            } else {
                ProgressView()
                    .frame(width: 50, height: 50)
                    .progressViewStyle(.circular)
                    .ignoresSafeArea(edges: .bottom)
            }
            
                
//            ZStack {
//                Rectangle()
//                    .frame(width: 200, height: 100)
//                    .foregroundColor(.white)
//                    .border(.black)
//                    .onTapGesture {
//                        let selected = viewModel.selection ?? Challenge(id: 1, challengeId: 1, name: "empty", difficulty: "easy", category: "quiz", description: "empty", coordinates: CLLocationCoordinate2D(latitude: 60, longitude: 24))
//                        print("open: \(viewModel.challengeInfoOpen) selection: \(selected)")
//                    }
//                VStack(spacing: 10) {
//                    Text("latitude: \(viewModel.userLatitude)")
//                    Text("longitude: \(viewModel.userLongitude)")
//                }
//
//            }
            if viewModel.challengeInfoOpen && viewModel.selection != nil {
                Rectangle()
                    .ignoresSafeArea()
                    .opacity(0.45)
                    .onTapGesture {
                        viewModel.challengeInfoOpen = false
                    }
                ChallengeInfo(locationPassed: $viewModel.selection, challengeInfoOpened: $viewModel.challengeInfoOpen)
            }
        }
        .onAppear {
            dao.getChallenges()
            viewModel.getUserLocation()
        }
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
////        MapView(challengePassed: Challenge(id: 1, challengeId: 1, name: "quizzz", difficulty: "easy", category: "quiz", description: "Answer these 5 super easy questions you have 10 seconds per question.", coordinates: CLLocationCoordinate2D(latitude: 60.224810974873215, longitude: 24.75657413146672)))
////        MapViewCustom()
//    }
//}

// MARK: ChallengeInfo Component

struct ChallengeInfo: View {
    
    @State private var challengeInfoHeight: CGFloat = 350.0
    @State private var challengeInfoExpanded = false
    @State private var startingOffsetY: CGFloat = UIScreen.main.bounds.height * 0.6
    @State private var currentDragOffsetY: CGFloat = 0
    @State private var endingOffsetY: CGFloat = 0
    @State private var buttonOffsetY: CGFloat = 175
    @State private var buttonEndOffsetY: CGFloat = 0
    @State private var challengeStarted = false
    
    @Binding var locationPassed: Challenge?
    @Binding var challengeInfoOpened: Bool
    
    func getDifficultyColor() -> Color {
        switch locationPassed!.difficulty {
        case "hard":
            return Color("DifficultyHard")
        case "medium":
            return Color("DifficultyMedium")
        case "easy":
            return Color("DifficultyEasy")
        default:
            return Color(.black)
        }
    }
    
    
    func expandChallengeInfo() {
        withAnimation(.spring()) {
            challengeInfoHeight = UIScreen.main.bounds.height * 0.85
            endingOffsetY = -startingOffsetY + 15
            buttonEndOffsetY = 400
            challengeInfoExpanded = true
        }
    }
    
    func updateUI() {
        challengeStarted = true
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 50)
                .frame(width: UIScreen.main.bounds.width, height: challengeInfoHeight)
                .foregroundColor(.white)
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 100, height: 5)
                    .padding(.top)
                HStack(alignment: .center, spacing: 10){
                    Image("\(locationPassed!.icon)")
                        .padding(.top)
                    VStack {
                        Text("\(locationPassed!.name)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)
                            .frame(width: 200, alignment: .topLeading)
                        Text("\(locationPassed!.difficulty.capitalized)")
                            .font(.headline)
                            .foregroundColor(getDifficultyColor())
                            .frame(width: 200, alignment: .leading)
                    }
                    Text("+\(locationPassed!.points)")
                        .foregroundColor(Color("RankingUp"))
                }
                .frame(width: UIScreen.main.bounds.width - 35, alignment: .leading)
                if !challengeStarted {
                    Divider()
                        .padding(.top)
                        .frame(width: UIScreen.main.bounds.width - 40, height: 3)
                        .background(.gray)
                        .opacity(0.2)
                }
                if challengeInfoExpanded {
                    ChallengeContainer(challengeInfoOpened: $challengeInfoOpened,challenge: locationPassed!, notifyParent2: updateUI)
                        .padding(.top, 25)
                }
            }
            if !challengeInfoExpanded {
                Button(action: expandChallengeInfo) {
                    Text("Start")
                        .font(Font.customFont.btnText)
                        .fontWeight(.semibold)
                        .frame(width: 200)
                        .padding(.vertical, 10)
                        .background(Color("Button"))
                        .foregroundColor(.white)
                        .cornerRadius(70)
                }
                .offset(y: buttonOffsetY)
                .offset(y: buttonEndOffsetY)
            }
        }
        .offset(y: startingOffsetY)
        .offset(y: currentDragOffsetY)
        .offset(y: endingOffsetY)
        .gesture(
            DragGesture()
                .onChanged { value in
                    withAnimation(.spring()) {
                        currentDragOffsetY = value.translation.height
                        challengeInfoHeight = UIScreen.main.bounds.height * 0.85
                    }
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        if currentDragOffsetY < -150 {
                            endingOffsetY = -startingOffsetY + 15
                            buttonEndOffsetY = 400
                            challengeInfoExpanded = true
                        } else if endingOffsetY != 0 && currentDragOffsetY > 150 {
                            endingOffsetY = 0
                            buttonEndOffsetY = 0
                            challengeInfoExpanded = false
                        }
                        currentDragOffsetY = 0
                    }
                }
        )
    }
}

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
        mapView.mapType = .satelliteFlyover
        
        let overlay = MKCircle(center: viewModel.userLocation ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), radius: 150)
        mapView.addOverlay(overlay)
        var span: MKCoordinateSpan
        if (viewModel.userLocation != nil) {
            span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.001)
        } else {
            span = MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
        }
        mapView.setRegion(MKCoordinateRegion(center: viewModel.userLocation ?? CLLocationCoordinate2D(latitude: 61.9241, longitude: 25.75482), span: span), animated: true)
//        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 61.9241, longitude: 25.7482), span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10))
        mapView.addAnnotations(annotations)
//        mapView.setRegion(region, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<MapViewCustom>) {
        let location = viewModel.userLocation ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
        print("userlocation \(location)")
        
    }
}

// MARK: MapViewCustom Coordinator

class Coordinator: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate{
    @Published var userLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @ObservedObject var viewModel: MapViewModel
    @ObservedObject var dao: ChallengeDAO
    @Published var selection: Challenge?
    var parent: MapViewCustom
    init(_ parent: MapViewCustom, vm: MapViewModel, dao: ChallengeDAO){
        self.parent = parent
        self.viewModel = vm
        self.dao = dao
    }
    
    private var locationManager: CLLocationManager?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location.coordinate
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
            print("title: \(String(describing: annotation.title ?? "no title"))")
            let annotation = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            annotation.image = UIImage(named: "quiz")
            annotation.frame.size = CGSize(width: 30, height: 30)
            return annotation
        }
        return nil
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotationTitle = view.annotation?.title {
            viewModel.challengeInfoOpen = true
            selection = dao.challenges.first(where:{ $0.name == annotationTitle && $0.coordinates == view.annotation!.coordinate})
            viewModel.selection = self.selection
//            viewModel.getChallengesInRange()
//            print("inrange \(String(describing: viewModel.challengesInRange))")
            mapView.setRegion(MKCoordinateRegion(center: view.annotation!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)), animated: true)
            
        }
    }
}
