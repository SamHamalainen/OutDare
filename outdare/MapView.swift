//
//  MapView.swift
//  outdare
//
//  Created by Sam Hämäläinen on 4.4.2022.
//

import SwiftUI
import MapKit

struct Location: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
    let icon: String
}

struct MapView: View {
    
    @StateObject private var viewModel = MapViewModel()
    @State private var challengeInfoOpened = false
    @State private var startingOffsetY: CGFloat = UIScreen.main.bounds.height * 0.6
    
    let challengeLocations = [
        Location(name: "S-market", coordinate: CLLocationCoordinate2D(latitude: 60.22506138615499, longitude: 24.759728409055466), icon: "tongueTwister"),
        Location(name: "Nokia networks", coordinate: CLLocationCoordinate2D(latitude: 60.224810974873215, longitude: 24.75657413146672), icon: "quiz"),
        Location(name: "Nokia building", coordinate: CLLocationCoordinate2D(latitude: 60.2218728358288, longitude: 24.755961678670257), icon: "singing"),
    ]
    
    var body: some View {
        ZStack(alignment: .top)  {
            Map(coordinateRegion: $viewModel.mapRegion,showsUserLocation: true, annotationItems: challengeLocations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Image(location.icon)
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
            }
            ChallengeInfo()
                .offset(y: startingOffsetY)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

struct ChallengeInfo: View {
    
    func test() {
        print("pressed button")
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 50)
                .frame(width: UIScreen.main.bounds.width, height: 350)
                .foregroundColor(.white)
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 100, height: 5)
                    .padding(.top)
                HStack(alignment: .center, spacing: 10){
                    Image("tongueTwister")
                        .padding(.top)
                    VStack {
                        Text("Tongue Twister")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)
                            .frame(width: 200, alignment: .topLeading)
                        Text("Hard")
                            .font(.headline)
                            .foregroundColor(Color("DifficultyHard"))
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
            }.padding(.top, 200)
        }
    }
}
