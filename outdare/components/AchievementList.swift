//  AchievementList.swift
//  outdare
//  Created by Jasmin Partanen on 26.4.2022.
//  Description: Grid view for showing achievement items
import SwiftUI

struct AchievementList: View {
    @StateObject private var vm = UserViewModel()
    
    // Choosing how much space each item takes in a column
    let columns = [
        GridItem(.adaptive(minimum: 80)),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView () {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(vm.achievementsWithCategory.sorted(by: { $0.id < $1.id }), id: \.self) { achievement in
                        NavigationLink(destination: AchievementDetail(achievement: achievement)) {
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
                }
                .padding(.horizontal)
                .padding(.bottom, UIScreen.main.bounds.height * 0.07)
            }
            .navigationBarHidden(true)
            .background(Color("Background2"))
            
        }
    }
}

struct AchievementList_Previews: PreviewProvider {
    static var previews: some View {
        AchievementList()
            .environmentObject(UserViewModel())
    }
}
