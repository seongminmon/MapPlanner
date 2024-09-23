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
            let date = plans.first?.date ?? Date()
            Text(date.toString("yyyy.MM.dd"))
                .font(.bold18)
                .padding(.top, 10)
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(plans, id: \.id) { item in
                        planCell(item: item)
                    }
                }
                .padding()
            }
        }
        .background(Color.clear)
        .presentationDetents([.fraction(0.4)])
    }
    
    private func planCell(item: Plan) -> some View {
        
        @State var showPlanDetailView = false
        
        return Button {
            showPlanDetailView.toggle()
        } label: {
            HStack(alignment: .top) {
                if item.photo, let image = ImageFileManager.shared.loadImageFile(filename: "\(item.id)") {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } else {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.appSecondary))
                        .frame(width: 100, height: 100)
                }
                VStack(alignment: .leading) {
                    Text(item.title)
                        .font(.bold15)
                        .foregroundStyle(Color(.appPrimary))
                    Text(item.contents ?? "")
                        .font(.regular13)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color(.appSecondary))
                        .lineLimit(2)
                }
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showPlanDetailView) {
            PlanDetailView(plan: item)
        }
    }
}
