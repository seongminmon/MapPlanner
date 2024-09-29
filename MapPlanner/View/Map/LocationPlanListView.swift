//
//  LocationPlanListView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/29/24.
//

import SwiftUI
import RealmSwift

struct LocationPlanListView: View {
    
    var location: Location?
    @StateObject private var planStore = PlanStore()
    
    var filteredPlans: [PlanOutput] {
        return planStore.outputPlans.filter { $0.locationID == location?.id }
    }
    
    var body: some View {
        VStack {
            Text(location?.placeName ?? "")
                .font(.bold18)
                .padding(.top, 10)
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(filteredPlans, id: \.id) { item in
                        PlanCell(plan: item)
                    }
                }
                .padding(.horizontal, 8)
            }
        }
        .background(Color.clear)
        .presentationDetents([.fraction(0.4)])
    }
}
