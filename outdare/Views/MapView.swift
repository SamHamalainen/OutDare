//
//  MapView.swift
//  outdare
//
//  Created by Sam Hämäläinen on 4.4.2022.
//  Description: View for showing a map with different challenges on it.

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var loginViewModel: AppViewModel
    @ObservedObject private var viewModel = MapViewModel()
    @ObservedObject var dao = ChallengeDAO()
    @ObservedObject private var navigationRoute = NavigationRoute()
    @State private var showingSheet = false
    @State var revealedChallenge = false
    
    // Toggle between follow mode and normal mode
    func setLocationToUser() {
        viewModel.userSelectedTracking.toggle()
    }
    
    // Change the buttons systemImage based on tracking status
    func updateUserLocationButtonUI() -> String {
        return viewModel.userSelectedTracking ? "location.fill" : "location"
    }
    
    // Directions sheet toggle
    func toggleShowingSheet() {
        showingSheet.toggle()
    }
    
    var body: some View {
        ZStack(alignment: .top)  {
            if !dao.annotations.isEmpty {
                MapViewCustom(
                    viewModel: viewModel,
                    dao: dao,
                    challengeInfoOpened: $viewModel.challengeInfoOpen,
                    navigationRoute: navigationRoute,
                    annotations: dao.annotations
                )
                .ignoresSafeArea(edges: .bottom)
                VStack {
                    Button(action: setLocationToUser) {
                        Image(systemName: updateUserLocationButtonUI())
                            .frame(width: 35, height: 35)
                            .background(.black)
                            .foregroundColor(.white)
                            .opacity(0.8)
                            .cornerRadius(10)
                    }
                    if !navigationRoute.directionsArray.isEmpty {
                            Button(action: toggleShowingSheet) {
                                Image(systemName: "arrow.triangle.turn.up.right.diamond")
                                    .frame(width: 35, height: 35)
                                    .background(.black)
                                    .foregroundColor(.white)
                                    .opacity(0.8)
                                    .cornerRadius(10)
                        }
                    }
                }
                .offset(x: UIScreen.main.bounds.width * 0.42, y: 25)
                if showingSheet {
                    DirectionsView(navigationRoute: navigationRoute, isOpen: $showingSheet)
                        .animation(.spring(), value: showingSheet)
                }
            } else {
                LottieView(lottieFile: "globeLoading", lottieLoopMode: .loop)
            }
            if viewModel.challengeInfoOpen && viewModel.selection != nil {
                Rectangle()
                    .ignoresSafeArea()
                    .opacity(0.45)
                    .onTapGesture {
                        viewModel.challengeInfoOpen = false
                        revealedChallenge = false
                    }
                ChallengeInfo(revealedChallenge: $revealedChallenge,
                              locationPassed: $viewModel.selection,
                              challengeInfoOpened: $viewModel.challengeInfoOpen,
                              userLocation: $viewModel.userLocation,
                              navigationRoute: navigationRoute
                )
            }
        }
        .onAppear {
            dao.getChallenges()
            loginViewModel.userDao.getLoggedInUserScore()
            self.viewModel.setup(self.loginViewModel.userDao, self.dao)
        }
    }
}

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapViewCustom()
//    }
//}

