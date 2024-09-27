//
//  PlanDetailView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/22/24.
//

import SwiftUI
import RealmSwift

struct PlanDetailView: View {
    
    var plan: PlanOutput
    @StateObject private var planStore = PlanStore()
    
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                if let image = ImageFileManager.shared.loadImageFile(filename: "\(plan.id)") {
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
                Text(plan.title)
                Text("\(plan.isTimeIncluded ? plan.date.toString("yyyy.MM.dd (E) a hh:mm") : plan.date.toString("yyyy.MM.dd (E)"))")
                Text(plan.contents)
                Text(plan.placeName)
                Text(plan.addressName)
                Text("\(String(describing: plan.lat))")
                Text("\(String(describing: plan.lng))")
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image.xmark
                    }
                    .foregroundStyle(Color(.appPrimary))
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    NavigationLink {
                        PlanEditView(plan: plan)
                    } label: {
                        Text("편집")
                    }
                    .foregroundStyle(Color(.appPrimary))
                    
                    Button {
                        showAlert.toggle()
                    } label: {
                        Text("삭제")
                    }
                    .foregroundStyle(Color(.destructive))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .alert("일정 삭제하기", isPresented: $showAlert) {
                Button("삭제", role: .destructive) {
                    planStore.deletePlan(planID: plan.id)
                }
                Button("취소", role: .cancel) {}
            }
        }
    }
}
