//
//  MapView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/13/24.
//

import SwiftUI

struct MapView: View {
    
    @StateObject var coordinator = Coordinator.shared
    
    var body: some View {
        VStack {
            NaverMapView()
                .ignoresSafeArea(.all, edges: .top)
        }
        .onAppear {
            Coordinator.shared.checkIfLocationServiceIsEnabled()
        }
    }
}

#Preview {
    MapView()
}
