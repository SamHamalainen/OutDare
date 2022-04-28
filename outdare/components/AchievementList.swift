//
//  AchievementList.swift
//  outdare
//
//  Created by Jasmin Partanen on 26.4.2022.
//

import SwiftUI

struct AchievementList: View {
    @StateObject private var vm = UserViewModel()
    
    let columns = [
            GridItem(.adaptive(minimum: 80)),
        ]
    
    var body: some View {
        ScrollView () {
            LazyVGrid(columns: columns, spacing: 10) {
            ForEach(vm.achievementsWithCategory, id: \.self) { achievement in
                ZStack {
                RoundedRectangle(cornerRadius: 45)
                        .foregroundColor(Color.theme.textLight)
                        .shadow(color: Color.theme.icon, radius: 2, x: 2, y: 3)
                        .frame(width: 80, height: 80)
                    AchievementItem(achievements: achievement)
                        .padding(.horizontal, 15)
                }
            }
        }
            .frame(maxHeight: 300)
            .padding(.horizontal)
        }
    }
}

struct AchievementList_Previews: PreviewProvider {
    static var previews: some View {
        AchievementList()
            .environmentObject(UserViewModel())
    }
}
