//
//  PlanEditView.swift
//  MapPlanner
//
//  Created by 김성민 on 9/23/24.
//

import SwiftUI
import RealmSwift

struct PlanEditView: View {
    
    @ObservedRealmObject var plan: Plan
    
    var body: some View {
        Text("PlanEditView")
    }
}
