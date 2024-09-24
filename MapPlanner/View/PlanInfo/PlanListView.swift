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

struct PlanCell: View {
    
    var plan: Plan
    @State var showPlanDetailView = false
    
    var body: some View {
        Button {
            showPlanDetailView.toggle()
        } label: {
            HStack(alignment: .top) {
                if plan.photo, let image = ImageFileManager.shared.loadImageFile(filename: "\(plan.id)") {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    Image.calendar
                        .foregroundStyle(Color(.appPrimary))
                        .frame(width: 100, height: 100)
                        .background(Color(.appSecondary))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                VStack(alignment: .leading) {
                    Text(plan.title)
                        .font(.bold15)
                        .foregroundStyle(Color(.appPrimary))
                    Text(plan.contents ?? "")
                        .font(.regular13)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color(.appSecondary))
                        .lineLimit(2)
                }
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showPlanDetailView) {
            PlanDetailView(plan: plan)
        }
    }
}
