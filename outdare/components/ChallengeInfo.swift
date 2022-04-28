//
//  ChallengeInfo.swift
//  outdare
//
//  Created by Sam Hämäläinen on 14.4.2022.
//

import SwiftUI
import MapKit

// MARK: ChallengeInfo Component

struct ChallengeInfo: View {
    
    @State private var challengeInfoHeight: CGFloat = 350.0
    @State private var challengeInfoExpanded = false
    @State private var startingOffsetY: CGFloat = UIScreen.main.bounds.height * 0.5
    @State private var currentDragOffsetY: CGFloat = 0
    @State private var endingOffsetY: CGFloat = 0
    @State private var buttonOffsetY: CGFloat = 175
    @State private var buttonEndOffsetY: CGFloat = 0
    @State private var challengeStarted = false
    @State private var showingAlert = false
    @Binding var revealedChallenge: Bool
    
    @Binding var locationPassed: Challenge?
    @Binding var challengeInfoOpened: Bool
    @Binding var userLocation: CLLocationCoordinate2D?
    @ObservedObject var navigationRoute: NavigationRoute
    
    @EnvironmentObject var userVM: AppViewModel
    
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
        challengeStarted.toggle()
    }
    
    private func addToRouteFirst() {
        guard let source = userLocation else { return }
        guard let destination = locationPassed else { return }
        navigationRoute.addDirections(from: source, to: destination, option: .makeFirst)
    }
    private func addToRouteLast() {
        guard let source = navigationRoute.directionsArray.last?.destination.coordinates else { return }
        navigationRoute.addDirections(from: source, to: locationPassed!, option: .makeLast)
    }
    
    func showAlert() {
        showingAlert = true
        userVM.userDao.getLoggedInUserScore()
    }
    
    func revealChallenge() {
        revealedChallenge = true
        userVM.userDao.updateUsersScore(newScore: -25)
    }
    
    var body: some View {
        if let userLocation = userLocation {
            if (locationPassed?.coordinates.distance(to: userLocation))! >= 150 && revealedChallenge == false {
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
                        Divider()
                            .padding(.top)
                            .frame(width: UIScreen.main.bounds.width - 40, height: 3)
                            .background(.gray)
                            .opacity(0.2)
                    }
                    VStack {
                        Button(action: {showAlert()}) {
                                Text("Reveal Challenge")
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
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("Are you sure you want to reveal challenge?"),
                                  message: Text("Once you reveal this challenge you will have to finish the challenge or else you will have to reveal it again. Revealing will cost 50 points."),
                                  primaryButton: .default(Text("Reveal")) {
                                revealChallenge()
                            },
                                  secondaryButton: .cancel())
                        }
                        Button(action: {addToRouteFirst()
                            challengeInfoOpened = false
                        }) {
                            Text("Add to the route(first)")
                                .font(Font.customFont.btnText)
                                .fontWeight(.semibold)
                                .frame(width: 250)
                                .padding(.vertical, 10)
                                .background(Color("Button"))
                                .foregroundColor(.white)
                                .cornerRadius(70)
                        }
                        .offset(y: buttonOffsetY)
                        .offset(y: buttonEndOffsetY)
                        Button(action: {
                            navigationRoute.directionsArray.isEmpty ? addToRouteFirst() : addToRouteLast()
                            challengeInfoOpened = false
                        }) {
                            Text("Add to the route(last)")
                                .font(Font.customFont.btnText)
                                .fontWeight(.semibold)
                                .frame(width: 250)
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
            } else if (locationPassed?.coordinates.distance(to: userLocation))! <= 150 || revealedChallenge {
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
                            ChallengeContainer(challengeInfoOpened: $challengeInfoOpened, revealedChallenge: $revealedChallenge,challenge: locationPassed!, notifyParent: updateUI)
                                .padding(.top)
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
    }
}


//struct ChallengeInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        ChallengeInfo()
//    }
//}
