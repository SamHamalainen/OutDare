//
//  CreateQuizForm.swift
//  outdare
//
//  Created by iosdev on 29.4.2022.
//

import SwiftUI
import CoreLocation
import MapKit
import SSToastMessage
import Subsonic

struct CreateQuizForm: View {
    @Binding var showForm: Bool
    @Binding var selected: [TriviaQuestion]
    @StateObject var dao = ChallengeDAO()
    @StateObject var mapVM = MapViewModel()
    @State var title: String = ""
    @State var description: String = ""
    @State var showMap = false
    @State var locationChosen = false
    @State var chosenCoords = CLLocationCoordinate2D()
    @State var showToast = false
    @State var message = ""
    @State var success = false
    @State var adding = false
    
    func handleCreate() {
        if title.isEmpty {
            message = "Please enter a title at least"
            showToast = true
        } else {
            adding = true
            dao.addQuiz(triviaQuestions: selected, title: title, description: description, coords: chosenCoords)
        }
    }
    
    var body: some View {
        let pinSize = CGFloat(30.0)
        ZStack {
            if adding {
                ProgressView()
                    .zIndex(1000)
            }
            Rectangle()
                .ignoresSafeArea()
                .opacity(0.45)
                .onTapGesture {
                    showForm = false
                }
            
            if showMap {
                ZStack {
                    Map(coordinateRegion: $mapVM.region)
                    Image(systemName: "mappin")
                        .font(.system(size: pinSize))
                        .foregroundColor(Color.theme.rankingDown)
                        .padding(.bottom, pinSize)
                    VStack {
                        Spacer()
                        Button(action: {
                            chosenCoords = mapVM.region.center
                            showMap = false
                            locationChosen = true
                        }) {
                            Text("Choose location")
                                .padding(.vertical, 10)
                                .frame(width: 200)
                                .font(Font.customFont.btnText)
                                .background(Color.theme.button)
                                .foregroundColor(Color.white)
                                .cornerRadius(40)
                        }
                        .padding(.bottom, 30)
                    }
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                mapVM.getUserLocation()
                            }) {
                                Image(systemName: "location.fill")
                                    .frame(width: 35, height: 35)
                                    .background(.black)
                                    .foregroundColor(.white)
                                    .opacity(0.8)
                                    .cornerRadius(10)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                }                
                .zIndex(100)
            }
            VStack {
                if success {
                    VStack(spacing: 40) {
                        Text("Quiz Added 🤩")
                            .font(Font.customFont.largeText)
                        Button(action: {
                            showForm = false
                        }) {
                            Text("Continue")
                                .padding(.vertical, 10)
                                .frame(width: 200)
                                .font(Font.customFont.btnText)
                                .background(Color.theme.background)
                                .foregroundColor(Color.white)
                                .cornerRadius(40)
                        }
                    }
                    .padding()
                } else {
                    Text("New Quiz")
                        .font(Font.customFont.largeText)
                        .padding(.bottom)
                    VStack(spacing: 15) {
                        TextField("Title", text: $title)
                            .textFieldStyle(RoundedTextFieldStyle())
                        
                        TextField("Description", text: $description)
                            .textFieldStyle(RoundedTextFieldStyle())
                        
                        if locationChosen {
                            HStack(spacing: 20) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(Color.theme.background)
                                    .font(.system(size: 40))
                                VStack(alignment: .trailing, spacing: 10) {
                                    Text("\(chosenCoords.latitude)")
                                        .font(Font.customFont.normalText)
                                    Text("\(chosenCoords.longitude)")
                                        .font(Font.customFont.normalText)
                                }
                            }
                            .padding(.top)
                        }
                    }
                    .padding(.bottom)
                    Button(action: {
                        if !locationChosen {
                            mapVM.getUserLocation()
                        }
                        showMap = true
                    }) {
                        Text("Choose location")
                            .padding(.vertical, 10)
                            .frame(width: 200)
                            .font(Font.customFont.btnText)
                            .background(Color.theme.button)
                            .foregroundColor(Color.white)
                            .cornerRadius(40)
                    }
                    
                    if locationChosen {
                        Button(action: {
                            handleCreate()
                        }) {
                            Text("Create Quiz!")
                                .padding(.vertical, 10)
                                .frame(width: 200)
                                .font(Font.customFont.btnText)
                                .background(Color.theme.background)
                                .foregroundColor(Color.white)
                                .cornerRadius(40)
                        }
                    }
                }
                
            }
            .padding()
            .padding(.vertical)
            .background(Color.theme.background2)
            .cornerRadius(30)
            .zIndex(10)
            .padding()
        }
        .onChange(of: dao.challengeAdded, perform: { added in
            play(sound: "correct.mp3")
            success = added
            adding = false
        })
        .allowsHitTesting(!adding)
        .present(isPresented: self.$showToast, type: .toast, position: .bottom, autohideDuration: 2.0) {
            Text(message)
                .padding()
                .background(Color.theme.backgroundOverlay)
                .opacity(0.9)
                .font(Font.customFont.smallText)
                .cornerRadius(10)
                .padding()
        }
    }
}

struct CreateQuizForm_Previews: PreviewProvider {
    static var previews: some View {
        CreateQuizForm(showForm: .constant(true), selected: .constant(TriviaQuestion.sample))
    }
}


