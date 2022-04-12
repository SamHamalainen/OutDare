//
//  MapView.swift
//  outdare
//
//  Created by Sam Hämäläinen on 4.4.2022.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @StateObject private var viewModel = MapViewModel()
    @State var challengeInfoOpened = false
    @State var challengePassed: Challenge?
    
    
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
            MapViewCustom()
            ZStack {
                Rectangle()
                    .frame(width: 200, height: 100)
                    .foregroundColor(.white)
                .border(.black)
                VStack(spacing: 10) {
                    Text("latitude: \(viewModel.userLatitude)")
                    Text("longitude: \(viewModel.userLongitude)")
                }

            }
            if challengeInfoOpened {
                Rectangle()
                    .ignoresSafeArea()
                    .opacity(0.45)
                    .onTapGesture {
                        challengeInfoOpened = false
                    }
                ChallengeInfo(locationPassed: $challengePassed, challengeInfoOpened: $challengeInfoOpened)
            }
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


struct MapViewCustom: UIViewRepresentable {
    @ObservedObject var viewModel = MapViewModel()
    @StateObject var dao = ChallengeDAO()
    @State var annotations: [MKAnnotation] = []
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func challengeToAnnotation() {
        var count = 0
        dao.challenges.forEach { challenge in
            let annotation = MKPointAnnotation()
            annotation.coordinate = challenge.coordinates
            annotation.title = "annotation \(count + 1)"
            annotations.append(annotation)
            count += 1
        }
        
    }
    
    func makeUIView(context: Context) -> MKMapView {
        viewModel.checkIfLocationServicesIsEnabled()
        print("dao has \(dao.challenges)")
        challengeToAnnotation()
        let mapView = MKMapView()
        
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        
        
        let overlay = MKCircle(center: CLLocationCoordinate2D(latitude: viewModel.userLatitude, longitude: viewModel.userLongitude), radius: 100)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: viewModel.userLatitude, longitude: viewModel.userLongitude), span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        mapView.addOverlay(overlay)
        mapView.setRegion(region, animated: true)
        
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: UIViewRepresentableContext<MapViewCustom>) {
        print("annotations \(annotations)")
        print("dao has in update \(dao.challenges)")
        print("map region \(mapView.centerCoordinate)")
        mapView.addAnnotations(annotations)
    }
}

class Coordinator: NSObject, MKMapViewDelegate, CLLocationManagerDelegate{
    var parent: MapViewCustom
    init(_ parent: MapViewCustom){
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let circle = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(circle: circle)
            circleRenderer.fillColor = UIColor.orange
            return circleRenderer
        }
        return MKOverlayRenderer()
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            let pin = mapView.view(for: annotation) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pin.image = UIImage(systemName: "person.circle.fill")
            return pin
        } else if annotation is MKPointAnnotation {
            let identifier = "Annotation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView!.canShowCallout = true
            } else {
                annotationView!.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
}
