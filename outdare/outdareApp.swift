//
//  outdareApp.swift
//  outdare
//
//  Created by Jasmin Partanen on 4.4.2022.
//

import SwiftUI
import Firebase

@main
struct outdareApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
//    @StateObject private var modelData = UserViewModel()
    @State var showMap = false
    @StateObject var viewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showMap {
                    MainView()
                        .environmentObject(viewModel)
                } else {
                    openingpageView()
                        .environmentObject(viewModel)
                }
            }
            .onChange(of: viewModel.signedIn) { signedIn in
                showMap = signedIn
            }
            .onAppear {
                showMap = viewModel.signedIn
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
    [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      
        FirebaseApp.configure()
        
        return true
    }
}
