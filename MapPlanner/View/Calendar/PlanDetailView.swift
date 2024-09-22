//
//  PlanDetailView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/22/24.
//

import SwiftUI
import RealmSwift

struct PlanDetailView: View {
    
    @ObservedRealmObject var plan: Plan
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Text("\(plan.title)\n\(plan.date)")
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
                        EditPlanView()
                    } label: {
                        Text("편집")
                    }
                    .foregroundStyle(Color(.appPrimary))
                    
                    Button {
                        print("삭제 탭")
                    } label: {
                        Text("삭제")
                    }
                    .foregroundStyle(Color(.destructive))
                }
            }
        }
    }
}
