//
//  outdareApp.swift
//  outdare
//
//  Created by Jasmin Partanen on 4.4.2022.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct outdareApp: App {
    //    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    //    @StateObject private var modelData = UserViewModel()
    init (){
        FirebaseApp.configure()
    }
    @State var login = false
    @StateObject var viewModel = AppViewModel()
    
    
    var body: some Scene {
        WindowGroup {
            Group {
                let auth = Auth.auth()
                if auth.currentUser != nil {
                    MainView()
                        .environmentObject(viewModel)
                }else{
                    if !login {
                        OpeningPageView(login: $login)
                            .environmentObject(viewModel)
                    }else{
                        LogInOrSignIn()
                            .environmentObject(viewModel)
                    }
                }
            }
        }
    }
}

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
//    [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//
//        FirebaseApp.configure()
//
//        return true
//    }
//}
