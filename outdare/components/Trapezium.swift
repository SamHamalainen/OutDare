//
//  Trapezium.swift
//  outdare
//
//  Created by Jasmin Partanen on 5.4.2022.
//

import SwiftUI

struct TrapeziumShape: Shape {
    var offset: CGFloat = 0.0
    var corner: UIRectCorner = .bottomLeft
    
    // Conditional drawing
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: corner == .topLeft ? rect.maxY * offset : 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: corner == .topRight ? rect.maxY * offset : 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: corner == .bottomLeft ? rect.maxY * offset : rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct Trapezium: View {
    var body: some View {
        VStack(spacing: -50) {
            TrapeziumShape(offset: 0.9, corner: .bottomLeft)
                .fill(Color.theme.background)
            TrapeziumShape(offset: 0.1, corner: .topRight)
                .fill(Color.theme.background2)
        }
        .frame(maxHeight: .infinity)
        .edgesIgnoringSafeArea(.vertical)
    }
}

struct Trapezium_Previews: PreviewProvider {
    static var previews: some View {
        Trapezium()
    }
}
