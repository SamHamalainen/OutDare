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
    
    var body: some View {
        ZStack(alignment: .top)  {
            if !dao.annotations.isEmpty && viewModel.userLocation != nil {
                MapViewCustom(
                    viewModel: viewModel,
                    dao: dao, challengeInfoOpened: $viewModel.challengeInfoOpen,
                    annotations: dao.annotations
                )
                .ignoresSafeArea(edges: .bottom)
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
                ChallengeInfo(locationPassed: $viewModel.selection, challengeInfoOpened: $viewModel.challengeInfoOpen, userLocation: $viewModel.userLocation)
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

