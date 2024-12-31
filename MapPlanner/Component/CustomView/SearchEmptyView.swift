//
//  SearchEmptyView.swift
//  MapPlanner
//
//  Created by 김성민 on 10/4/24.
//

import SwiftUI

struct SearchEmptyView: View {
    var body: some View {
        Text("검색 결과가 없습니다.")
            .asTextModifier(font: .bold20, color: .appPrimary)
            .asHideKeyboardModifier()
    }
}
