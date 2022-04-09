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
    @State private var challengeInfoOpened = false
    @State var challengePassed: Challenge?
    @StateObject var dao = ChallengeDAO()
    
    var body: some View {
        ZStack(alignment: .top)  {
            Map(coordinateRegion: $viewModel.mapRegion,showsUserLocation: true, annotationItems: dao.challenges) { challenge in
                MapAnnotation(coordinate: challenge.coordinates) {
                    Image(challenge.icon)
                        .onTapGesture {
                            print("clicked on \(challenge.name)")
                            challengePassed = challenge
                            challengeInfoOpened = true
                        }
                        .contrast(0.3)
                }
            }
            .ignoresSafeArea()
            .onAppear {
                viewModel.checkIfLocationServicesIsEnabled()
                dao.getChallenges()
            }
            .overlay {
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.red)
                    .opacity(0.3)
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
        MapView(challengePassed: Challenge(id: 1, challengeId: 1, name: "quizzz", difficulty: "easy", category: "quiz", description: "Answer these 5 super easy questions you have 10 seconds per question.", coordinates: CLLocationCoordinate2D(latitude: 60.224810974873215, longitude: 24.75657413146672)))
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
    @State private var challengeStarted = false
    
    @Binding var locationPassed: Challenge?
    
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
            challengeInfoHeight = UIScreen.main.bounds.height * 0.9
            endingOffsetY = -startingOffsetY
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
                    ChallengeContainer(challenge: locationPassed!, notifyParent2: updateUI)
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
