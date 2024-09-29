//
//  TimeLineView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/23/24.
//

import SwiftUI

struct TimeLineView: View {
    
    @StateObject private var planStore = PlanStore()
    
    var sortedPlan: [PlanOutput] {
        return planStore.outputPlans.sorted { $0.date > $1.date }
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack {
                    ForEach(sortedPlan, id: \.id) { item in
                        VStack {
                            Text(item.date.toString(DateFormat.untilDay))
                                .font(.bold18)
                            PlanCell(plan: item)
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            AddPlanButton()
        }
    }
}
