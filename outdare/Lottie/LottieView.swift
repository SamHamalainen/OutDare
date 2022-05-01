//
//  LottieView.swift
//  outdare
//
//  Created by Jasmin Partanen on 29.4.2022.
//  Description: Lottie wrapper for the lottie view

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let lottieFile: String
    var lottieLoopMode: LottieLoopMode = .playOnce
    let animationView = AnimationView()
    
    // Loading JSON and setting it to animation property
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        
        animationView.animation = Animation.named(lottieFile)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = lottieLoopMode
        animationView.play()
        
        view.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}
