//
//  PlanCell.swift
//  MapPlanner
//
//  Created by 김성민 on 9/25/24.
//

import SwiftUI

struct PlanCell: View {
    
    var plan: PlanOutput
    @State var showPlanDetailView = false
    
    var body: some View {
        Button {
            showPlanDetailView.toggle()
        } label: {
            HStack(alignment: .top) {
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
                
                VStack(alignment: .leading) {
                    Text(plan.title)
                        .font(.bold15)
                        .foregroundStyle(Color(.appPrimary))
                    Text(plan.contents)
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
