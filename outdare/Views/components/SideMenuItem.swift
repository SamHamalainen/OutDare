//
//  SideMenuItem.swift
//  outdare
//
//  Created by Tatu Ihaksi on 6.4.2022.
//

import SwiftUI

struct SideMenuItem: View {
    let viewModel: SideMenuViewModel
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: viewModel.imageName)
                .frame(width: 25, height: 25)
            Text(viewModel.title).font(.system(size: 15, weight: .semibold))
            Spacer()
        }
        .foregroundColor(Color("TextDark"))
        .padding()
    }
}

struct SideMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuItem(viewModel: .map)
    }
}
