//
//  SideMenuItem.swift
//  outdare
//
//  Created by iosdev on 6.4.2022.
//

import SwiftUI

struct SideMenuItem: View {
    let viewModel: SideMenuViewModel
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: viewModel.imageName)
                .frame(width: 24, height: 24)
            Text(viewModel.title).font(.system(size: 15, weight: .semibold))
            Spacer()
        }
        .foregroundColor(.black)
        .padding()
    }
}

struct SideMenuItem_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuItem(viewModel: .map)
    }
}
