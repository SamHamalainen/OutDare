//
//  CheckPreviousRanking.swift
//  outdare
//
//  Created by Jasmin Partanen on 14.4.2022.
//
import SwiftUI

struct GetCurrentUserPrevRanking: View {
    @ObservedObject private var vm = UserViewModel()
    
    var body: some View {
            if vm.currentUser?.goneUp == true {
                Image(systemName: "arrowtriangle.up.fill")
                    .foregroundColor(Color.theme.rankingUp)
            } else {
                Image(systemName: "arrowtriangle.down.fill")
                    .foregroundColor(Color.theme.rankingDown)
        }
    }
}

struct GetCurrentUserPrevRanking_Previews: PreviewProvider {
    static var previews: some View {
        GetCurrentUserPrevRanking()
    }
}
