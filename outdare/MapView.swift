//
//  MapView.swift
//  outdare
//
//  Created by Sam Hämäläinen on 4.4.2022.
//

import SwiftUI
import MapKit

struct Challenge: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let icon: String
    let difficulty: String
}

struct MapView: View {
    
    @StateObject private var viewModel = MapViewModel()
    @State private var challengeInfoOpened = false
    @State var challengePassed: Challenge?
    
    
    
    let challengeLocations = [
        Challenge(name: "Tongue Twister", coordinate: CLLocationCoordinate2D(latitude: 60.22506138615499, longitude: 24.759728409055466), icon: "tongueTwister", difficulty: "Hard"),
        Challenge(name: "Quiz", coordinate: CLLocationCoordinate2D(latitude: 60.224810974873215, longitude: 24.75657413146672), icon: "quiz", difficulty: "Easy"),
        Challenge(name: "Finish the Lyrics", coordinate: CLLocationCoordinate2D(latitude: 60.2218728358288, longitude: 24.755961678670257), icon: "singing", difficulty: "Medium"),
    ]
    
    var body: some View {
        ZStack(alignment: .top)  {
            Map(coordinateRegion: $viewModel.mapRegion,showsUserLocation: true, annotationItems: challengeLocations) { challenge in
                MapAnnotation(coordinate: challenge.coordinate) {
                    Image(challenge.icon)
                        .onTapGesture {
                            print("clicked on \(challenge.name)")
                            challengePassed = challenge
                            challengeInfoOpened = true
                        }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                viewModel.checkIfLocationServicesIsEnabled()
            }
            if challengeInfoOpened {
                    Rectangle()
                        .ignoresSafeArea()
                        .opacity(0.45)
                        .onTapGesture {
                            challengeInfoOpened = false
                        }
                    ChallengeInfo(locationPassed: $challengePassed)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(challengePassed: Challenge(name: "Tongue Twister", coordinate: CLLocationCoordinate2D(latitude: 60.22506138615499, longitude: 24.759728409055466), icon: "tongueTwister", difficulty: "Hard"))
    }
}

// MARK: ChallengeInfo Component

struct ChallengeInfo: View {
    
    @State private var challengeInfoHeight: CGFloat = 350.0
    @State private var challengeInfoExpanded = false
    @State private var startingOffsetY: CGFloat = UIScreen.main.bounds.height * 0.6
    @State private var currentDragOffsetY: CGFloat = 0
    @State private var endingOffsetY: CGFloat = 0
    @State private var buttonOffsetY: CGFloat = 200
    @State private var buttonEndOffsetY: CGFloat = 0
    
    @Binding var locationPassed: Challenge?
    
    func getDifficultyColor() -> Color {
        switch locationPassed!.difficulty {
        case "Hard":
            return Color("DifficultyHard")
        case "Medium":
            return Color("DifficultyMedium")
        case "Easy":
            return Color("DifficultyEasy")
        default:
            return Color(.black)
        }
    }
    
    
    func test() {
        print("pressed button")
        print("expanded: \(challengeInfoExpanded)")
        print("\(locationPassed!)")
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
                        Text("\(locationPassed!.difficulty)")
                            .font(.headline)
                            .foregroundColor(getDifficultyColor())
                            .frame(width: 200, alignment: .leading)
                    }
                    Text("+100")
                        .foregroundColor(Color("RankingUp"))
                }
                .frame(width: UIScreen.main.bounds.width - 35, alignment: .leading)
                Divider()
                    .padding(.top)
                    .frame(width: UIScreen.main.bounds.width - 40, height: 3)
                    .background(.gray)
                    .opacity(0.2)
            }
            Button(action: test) {
                Text("Start")
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(width: 250, height: 50)
                    .background(Color("Button"))
                    .foregroundColor(.white)
                    .cornerRadius(70)
            }
            .offset(y: buttonOffsetY)
            .offset(y: buttonEndOffsetY)
        }
        .offset(y: startingOffsetY)
        .offset(y: currentDragOffsetY)
        .offset(y: endingOffsetY)
        .gesture(
            DragGesture()
                .onChanged { value in
                    withAnimation(.spring()) {
                        currentDragOffsetY = value.translation.height
                        challengeInfoHeight = UIScreen.main.bounds.height * 0.9
                    }
                }
                .onEnded { value in
                    withAnimation(.spring()) {
                        if currentDragOffsetY < -150 {
                            endingOffsetY = -startingOffsetY
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
