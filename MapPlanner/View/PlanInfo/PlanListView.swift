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
    @ObservedResults(Plan.self) var plans
    
    var filteredPlans: [Plan] {
        return plans.filter { $0.date.compareYearMonthDay(date) }
    }
    
    var body: some View {
        VStack {
            Text(date.toString("yyyy.MM.dd"))
                .font(.bold18)
                .padding(.top, 10)
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(filteredPlans, id: \.id) { item in
                        PlanCell(plan: item)
                    }
                }
                .padding()
            }
        }
        .background(Color.clear)
        .presentationDetents([.fraction(0.4)])
    }
}
