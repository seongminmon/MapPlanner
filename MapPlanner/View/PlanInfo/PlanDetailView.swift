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
    @State private var showDeleteAlert = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    // 사진
                    imageView()
                    VStack(spacing: 20) {
                        Text(plan.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(plan.isTimeIncluded ? plan.date.toString("yyyy.MM.dd (E) a hh:mm") : plan.date.toString("yyyy.MM.dd (E)"))")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(plan.contents)
                            .font(.regular14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(plan.placeName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(plan.addressName)
                            .font(.regular14)
                            .foregroundStyle(Color(.appSecondary))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .font(.bold15)
                    .foregroundStyle(Color(.appPrimary))
                    .padding()
                }
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
                        showDeleteAlert.toggle()
                    } label: {
                        Text("삭제")
                    }
                    .foregroundStyle(Color(.destructive))
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            .alert("일정 삭제하기", isPresented: $showDeleteAlert) {
                Button("삭제", role: .destructive) {
                    planStore.deletePlan(planID: plan.id)
                }
                Button("취소", role: .cancel) {}
            }
        }
    }
    
    @ViewBuilder
    private func imageView() -> some View {
        if let image = ImageFileManager.shared.loadImageFile(filename: "\(plan.id)") {
            Image(uiImage: image)
                .resizable()
                .frame(maxWidth: .infinity)
                .frame(height: 300)
        } else {
            Image.camera
                .resizable()
                .frame(width: 50, height: 40)
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .foregroundStyle(Color(.appPrimary))
                .background(Color(.appSecondary))
            
        }
    }
}
