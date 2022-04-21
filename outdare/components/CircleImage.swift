//
//  CircleImage.swift
//  outdare
//
//  Created by Jasmin Partanen on 7.4.2022.
//

import SwiftUI

struct CircleImage: View {
    var image: Image
    
    var body: some View {
        image
            .clipShape(Circle())
            .overlay {
                Circle().stroke(Color.theme.stroke, lineWidth: 5)
            }
            .shadow(radius: 7)
            .frame(width: 125, height: 125)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image: Image("profile1"))
    }
}
