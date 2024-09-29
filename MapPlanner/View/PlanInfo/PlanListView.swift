//
//  PlanListView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/23/24.
//

import SwiftUI
import RealmSwift

struct PlanListView: View {
    
    var date: Date
    @StateObject private var planStore = PlanStore()
    
    var filteredPlans: [PlanOutput] {
        return planStore.outputPlans.filter { $0.date.compareYearMonthDay(date) }
    }
    
    var body: some View {
        VStack {
            Text(date.toString(DateFormat.untilDay))
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
