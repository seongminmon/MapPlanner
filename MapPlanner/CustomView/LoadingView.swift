//
//  LoadingView.swift
//  MapPlanner
//
//  Created by 김성민 on 10/5/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .padding()
            .frame(width: 100, height: 100)
            .tint(.appSecondary)
            .background(.appSecondary.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
