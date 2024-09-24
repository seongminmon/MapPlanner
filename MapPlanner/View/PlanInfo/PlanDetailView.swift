//
//  PlanDetailView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/22/24.
//

import SwiftUI
import RealmSwift

struct PlanDetailView: View {
    
    // TODO: - 수정 시 변화 적용하기
    
    var plan: Plan
    @Environment(\.dismiss) private var dismiss
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text("\(plan.title)\n\(plan.date)")
            }
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
            .alert("일정 삭제하기", isPresented: $showAlert) {
                Button("삭제", role: .destructive) {
                    print("삭제 탭")
                    deletePlan()
                }
                Button("취소", role: .cancel) {}
            }
        }
    }
    
    private func deletePlan() {
        do {
            let realm = try Realm()
            guard let target = realm.object(ofType: Plan.self, forPrimaryKey: plan.id) else { return }
            try realm.write {
                realm.delete(target)
            }
            dismiss()
        } catch {
            print("Realm 삭제 실패: \(error)")
        }
    }
}
