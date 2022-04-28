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
    @ObservedObject var dao = ChallengeDAO()
    @ObservedObject private var navigationRoute = NavigationRoute()
    @State private var showingSheet = false
    @State var revealedChallenge = false
    @EnvironmentObject var loginViewModel: AppViewModel
    
    func setLocationToUser() {
        viewModel.userSelectedTracking.toggle()
    }
    
    func updateUserLocationButtonUI() -> String {
        return viewModel.userSelectedTracking ? "location.fill" : "location"
    }
    
    var body: some View {
        //let span = viewModel.mapRegion.span.latitudeDelta
        //let isZoomedOut = (span > 0.8) ? true : false
        
        ZStack(alignment: .top)  {
            if !dao.annotations.isEmpty {
                MapViewCustom(
                    viewModel: viewModel,
                    dao: dao, challengeInfoOpened: $viewModel.challengeInfoOpen,
                    navigationRoute: navigationRoute,
                    annotations: dao.annotations,
                    oldAnnotations: dao.oldAnnotations
                )
                .ignoresSafeArea(edges: .bottom)
                Button(action: setLocationToUser) {
                    Image(systemName: updateUserLocationButtonUI())
                        .frame(width: 35, height: 35)
                        .background(.black)
                        .foregroundColor(.white)
                        .opacity(0.8)
                        .cornerRadius(10)
                }
                .offset(x: UIScreen.main.bounds.width * 0.42, y: 25)
                let formatted = String(format: "Distance: %.1f meters", viewModel.distanceTravelled)
                Text("\(formatted)")
                    .padding(.top, 150)
                
                
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
                    .ignoresSafeArea(edges: .bottom)
                    .scaleEffect(x: 2, y: 2, anchor: .center)
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
            Button("Directions info") {
                showingSheet.toggle()
            }.background(.white).frame(height: 50)
            if showingSheet {
                DirectionsView(navigationRoute: navigationRoute, isOpen: $showingSheet)
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

