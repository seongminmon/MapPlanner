//
//  SearchEmptyView.swift
//  MapPlanner
//
//  Created by 김성민 on 10/4/24.
//

import SwiftUI

// TODO: - 키보드 안 내려가는 문제
struct SearchEmptyView: View {
    var body: some View {
        Text("검색 결과가 없습니다.")
            .asTextModifier(font: .bold20, color: .appPrimary)
            // 키보드 내리기
            .asHideKeyboardModifier()
    }
}
