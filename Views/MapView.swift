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
    
    func setLocationToUser() {
        print("user tracking before: \(viewModel.userSelectedTracking)")
        viewModel.userSelectedTracking.toggle()
        print("user tracking after: \(viewModel.userSelectedTracking)")
    }
    
    func updateUserLocationButtonUI() -> String {
        return viewModel.userSelectedTracking ? "location.fill" : "location"
    }
    
    var body: some View {
        //let span = viewModel.mapRegion.span.latitudeDelta
        //let isZoomedOut = (span > 0.8) ? true : false
        
        ZStack(alignment: .top)  {
            if !dao.annotations.isEmpty && viewModel.userLocation != nil {
                MapViewCustom(
                    viewModel: viewModel,
                    dao: dao, challengeInfoOpened: $viewModel.challengeInfoOpen,
                    navigationRoute: navigationRoute,
                    annotations: dao.annotations
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
                    }
                ChallengeInfo(locationPassed: $viewModel.selection, challengeInfoOpened: $viewModel.challengeInfoOpen, userLocation: $viewModel.userLocation, navigationRoute: navigationRoute)
            }
            Button("Directions info") {
                showingSheet.toggle()
            }.background(.white).frame(height: 50)
            .sheet(isPresented: $showingSheet) {
                DirectionsView(navigationRoute: navigationRoute)
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
//        MapViewCustom()
//    }
//}

