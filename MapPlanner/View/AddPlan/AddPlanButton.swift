//
//  AddPlanButton.swift
//  MapPlanner
//
//  Created by 김성민 on 9/23/24.
//

import SwiftUI

struct AddPlanButton: View {
    
    var date = Date()
    
    var body: some View {
        NavigationLink {
            AddPlanView(selectedDate: date)
        } label: {
            Image.plus
                .foregroundStyle(Color(.background))
                .padding()
                .frame(width: 50, height: 50)
                .background(Color(.appPrimary))
                .clipShape(Circle())
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        .padding()
    }
}
